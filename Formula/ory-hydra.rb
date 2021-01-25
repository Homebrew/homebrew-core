class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.9.0.tar.gz"
  sha256 "a317f194b3b22378f3a01af9ce395a4fb60541e58ca5f7171701f21146e87c18"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c68d6749b62a34ed6e8ce49fa487521a96668fd5240e7ae337d4bbae883ad31a" => :big_sur
    sha256 "b0291784d618cbb721bf802fd1c6b789561617577a12ec089aec935f1206ec6d" => :arm64_big_sur
    sha256 "ba93138fad45995274fdecd39c69cf80f6db1506df382bf033e112bde560cf58" => :catalina
    sha256 "50bded603ab420fd48498c0baff6b2e5f0a7645bac056690b0ed80857490a412" => :mojave
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
