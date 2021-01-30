class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.9.2.tar.gz"
  sha256 "717d27efdb302cae2a57b0664b8cf3cb493d10ac7750a25162778cc256b1c006"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e81542a9bad2cd7de922cc634f38a3836ca5ba1abb98739b6c8ff735a66c702d" => :big_sur
    sha256 "138f474ca11974be1e9f08a7d5efa94a6cac013e12a5ac1ce179af35ecdae9a9" => :arm64_big_sur
    sha256 "2d26a741b1be1d4b66110299774f6d43c6521ea876eee0e55131f6e2294f1ffc" => :catalina
    sha256 "39b5af96367b9cfd5e761809150d260de43cb997ee4053c5cce01f1bb3429b9b" => :mojave
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
