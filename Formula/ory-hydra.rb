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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba879bc22ba2d3782990c6c9d8145c7b37709c9cab99d36c15b8ae2cae08cb0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a1c64b5f91606768b4936dff612e82cec33b61a4ffeeb7ec2482a409d41c19f"
    sha256 cellar: :any_skip_relocation, catalina:      "d946e68b627af085c42aec6a4466cfcee394e5db905a1c1191732729241319f9"
    sha256 cellar: :any_skip_relocation, mojave:        "70f7583e99d4cd3f0c0b88c6498351bfab099f8a58b7c6856ec003582bff176e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f185f604a0a7d563cf645f49ec21a4d98293cc6e1a9c8c63678824b10a4039"
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
