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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecda15b4e0757d8309540c85cbd953cf8f62704079e5f40b03a9d0bb53b3ad68"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2f16a3c2706db86f7ae38c8c9c1e2354d8b3da233bc18d30a9e06580453adbc"
    sha256 cellar: :any_skip_relocation, catalina:      "657c5772b5dc40dbd552803476f8818607dec5b9c9c11f8770ae532eec821ab0"
    sha256 cellar: :any_skip_relocation, mojave:        "5d9e5f21ee311afdb04ab98212d82477b7354341366c130a3c01e9f0d25a238f"
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
