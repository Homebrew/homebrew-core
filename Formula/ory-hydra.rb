class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.8.5.tar.gz"
  sha256 "5cf0dbb44d837d32868edbf036e67b5fdfbb36b20b75eb2b022d3e42f87ead81"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1028b444425cf5a5c4251b7d8c44ce467ef912414e79c5947f7f1aea863db6f" => :catalina
    sha256 "32f30a7613dbf5db6cd9ee6315c45079798e10e144a7487bcb8bef7c50f00799" => :mojave
    sha256 "77047fb7d35683c1409749a7c105a37cc0bfa2c80640ee03c7bec1cacfb6758b" => :high_sierra
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
