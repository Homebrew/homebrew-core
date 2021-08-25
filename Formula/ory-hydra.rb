class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.10.5.tar.gz"
  sha256 "0d53fae9e0d2a93dfa285fe473a1d44f9663247739f9a0338c6c7c8e115a1a0a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37f660bfd89f1bc766d06397f71087bdbc6ed7cea28f25e1ab282d55fb1ab19e"
    sha256 cellar: :any_skip_relocation, big_sur:       "db58ee23f24377e5db80a9137b7c30c596540125705292f19bb921d4bb573e4d"
    sha256 cellar: :any_skip_relocation, catalina:      "fc6c7dda2fee18826f95fecb6740219b090522bc95fe364efe8117dba9954c52"
    sha256 cellar: :any_skip_relocation, mojave:        "9a9c01bb5fc78a8b2e0ccabc85963687eac4b4251df7be3cf15911553765bef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d3fc4944599a8101e9e0f985f0c3a84632c5bea97b72e6b531f2cdd3bdddbf"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/ory/hydra/commit/57b41e93f89ff847da0386a8315603bba203f417.patch?full_index=1"
    sha256 "9b51bb86935b53e30e7e1dc3585b94f4fd901e1127263b783110d7b1bb983e11"
  end

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
