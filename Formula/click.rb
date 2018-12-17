class Click < Formula
  desc "The command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.3.2.tar.gz"
  sha256 "eed648409bf78a05658a9d097e5099ca17bf19df70122e2067859ae94c5575d5"
  head "https://github.com/databricks/click.git"

  bottle do
    sha256 "20757fac7b6ce08e1bd3df5275988cbaff40319c1c990428ada624ae313a0aed" => :mojave
    sha256 "998198613be6e5007df66eee76b9ba108078c58534869a03233e8fed93661b32" => :high_sierra
    sha256 "f165b40c17fceaa2ceac1a745124008255986e1e8e6da98973aadc49095f62ea" => :sierra
    sha256 "fcfc3052c5457fae773d76e93d680c3033f54df048f66dd4c38148c684d986aa" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
