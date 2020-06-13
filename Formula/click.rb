class Click < Formula
  desc "The command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.5.3.tar.gz"
  sha256 "68feaa0d2a0c5b3a110eedd393949a89d6f80583eb25289161c0b91714097bed"
  head "https://github.com/databricks/click.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02b1de57a95bebb671d6f91e6c5549976c3aa87cf0fa69b9623e907d61d950a7" => :catalina
    sha256 "1cf4fbaf8c1ffe6e99d00b6b0d3b5ea283593d63042a27867f7e3e449543a8d6" => :mojave
    sha256 "3ee92f676ad91752748aa7a13a1909a43e3b34590f9458dd94a63a3b42fa1a02" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    mkdir testpath/"config"
    # Default state configuration file to avoid warning on startup
    (testpath/"config/click.config").write <<~EOS
      ---
      namespace: ~
      context: ~
      editor: ~
      terminal: ~
    EOS

    # Fake K8s configuration
    (testpath/"config/config").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            insecure-skip-tls-verify: true
            server: 'https://localhost:6443'
          name: test-cluster
      contexts:
        - context:
            cluster: test-cluster
            user: test-user
          name: test-context
      current-context: test-context
      kind: Config
      preferences:
        colors: true
      users:
        - name: test-cluster
          user:
            client-certificate-data: >-
              invalid
            client-key-data: >-
              invalid
    EOS

    # This test cannot test actual K8s connectivity, but it is enough to prove click starts
    (testpath/"click-test").write <<~EOS
      spawn "#{bin}/click" --config_dir "#{testpath}/config"
      expect "*\\[*none*\\]* *\\[*none*\\]* *\\[*none*\\]* >"
      send "quit\\r"
    EOS
    system "expect", "-f", "click-test"
  end
end
