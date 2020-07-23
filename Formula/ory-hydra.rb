class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.6.0.tar.gz"
  sha256 "d7deda97dc869aa0ae406614ff2776b79504c47cee282bd02fe002f7cf02cc41"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bc6be9f9dbd75db15304fc8e6e2eda6c398d75831285afe42986022781c9ab7" => :catalina
    sha256 "1dd0d349b402e1051ed828e1be9051af5e6cd816517c891d429d21bb576c1675" => :mojave
    sha256 "aae2b39200e3a5debd9840e6d0845f8268df4ab867ce2f6396620c5c4272b70d" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "hydra", :because => "both install `hydra` binaries"

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
