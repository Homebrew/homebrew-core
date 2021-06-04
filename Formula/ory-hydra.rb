class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.10.2.tar.gz"
  sha256 "4d4a19a79c927218fc9deb86502274935e9d88498fd906cb16a370b6ef73d6e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d15c34fb367173ea9b9c91083392ee051298c02fa86043ae2ccdeb833a916f33"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae797c3cdfefdc13c52d763fcaf49b8532ff41008a54e5d42f96a9f9ed90cffb"
    sha256 cellar: :any_skip_relocation, catalina:      "e0a603a3b8ea52b0ec88058ac9f31c93e9b7056c13cc0dd890a16ddd6ec8e2ad"
    sha256 cellar: :any_skip_relocation, mojave:        "1b4f543601ecbccb1f180a413ecd83164769bb12411a9861035865868917bc80"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"
  end

  test do
    admin_port = free_port
    (testpath/"config.yaml").write <<~EOS
      dsn: memory
      serve:
        public:
          port: #{free_port}
        admin:
          port: #{admin_port}
    EOS

    fork { exec bin/"hydra", "serve", "all", "--config", "#{testpath}/config.yaml" }
    sleep 20

    endpoint = "https://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra clients list --endpoint #{endpoint} --skip-tls-verify")
    assert_match "| CLIENT ID |", output
  end
end
