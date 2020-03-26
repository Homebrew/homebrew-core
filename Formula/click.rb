class Click < Formula
  desc "The command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.5.1.tar.gz"
  sha256 "bec44235f95a81076605bdec82bca72f7772ee713a6cf07b09bb522e9fe6a358"
  head "https://github.com/databricks/click.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "890704d50d503be704a4ba42eaf4e00744498018665c387dfdfbb3e8e90821c3" => :catalina
    sha256 "504036658e9d97db5629fbd60a42fe09c7d173a4d87369eb352db4882d4e40e5" => :mojave
    sha256 "e42bd20ff9d3f6fd6d0c298e6b9c1692a0fd0535156e9a4e70ff9964d79c3693" => :high_sierra
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
