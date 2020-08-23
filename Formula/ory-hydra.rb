class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.7.0.tar.gz"
  sha256 "984cb578bc499b72d3e4cf92315add0650681925aeaa68581515bf10c94f3e1f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f3a82862e3669005719c9c7b69e0c83b3e2523027bc5f64ff00d498c5649c53" => :catalina
    sha256 "fcfd384f726c51960f0103467e81f39e69ccb2ce434dd68134deb48e200ce50e" => :mojave
    sha256 "8e4cda62383e2cf4bff91cdc8a76fd25cc9bfc4880fd729b18c9a18e008b35a1" => :high_sierra
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
