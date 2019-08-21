class Click < Formula
  desc "The command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.4.2.tar.gz"
  sha256 "cc68454dc8d53904d6d972e60b7c38138967ee61b391143c68b5ef0a59043d4a"
  head "https://github.com/databricks/click.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b154b0c1375d2b0ce09ef9ee3b44dbc5a4b1387f6e341fceb7708177e2801208" => :mojave
    sha256 "287467bcb9ec9ef1adf4809e3a33ae64a26d17620e214fc833e979fb12c43e3c" => :high_sierra
    sha256 "c5690ca5166998c859d72b02ba9d44e4053fa9e3866626610fa332410571601f" => :sierra
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
