class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.9.2.tar.gz"
  sha256 "717d27efdb302cae2a57b0664b8cf3cb493d10ac7750a25162778cc256b1c006"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4992f21e72a0ee88749ad9d0c72064406b12ebffc020db178fda8617e199187e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f43c551ba78d8ed1b2c631c56953d160dafafd77c186cfff39471f8da7b156d"
    sha256 cellar: :any_skip_relocation, catalina:      "af687d0144096dd9baa3031dfc2e69fd5aa8fe95133e4eb8f4344738aaf374db"
    sha256 cellar: :any_skip_relocation, mojave:        "41a058f5adaf40bd23f206e9a2cb617df92dd30f4fbb841b099afead92e3987a"
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

    fork { exec bin/"hydra", "serve", "all", "--config", "config.yaml" }
    sleep 5

    endpoint = "https://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra clients list --endpoint #{endpoint} --skip-tls-verify")
    assert_match "| CLIENT ID |", output
  end
end
