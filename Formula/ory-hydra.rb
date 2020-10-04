class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.8.5.tar.gz"
  sha256 "5cf0dbb44d837d32868edbf036e67b5fdfbb36b20b75eb2b022d3e42f87ead81"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "719f44b5ccf00dc1a28f2c0032058ebf126f52fc74417a768c9ced9701e627b5" => :catalina
    sha256 "003c630ce678f5dc7cdc61bceb11bc130532d2cf3c8bd44fc360de261988631e" => :mojave
    sha256 "2bad2b83707f7035069cbf0db142c8e6f4ee4c9cb4107da9fd4142d51f6ffce3" => :high_sierra
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
