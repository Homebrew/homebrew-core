class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.6.2.tar.gz"
  sha256 "8caa28e3dd3af40e0a8686e86457baa65d0c8cea2c8c530ad4834f44694c31e4"
  license "Apache-2.0"
  head "https://github.com/databricks/click.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "378d469167903f2e710632b8772be7850479fb315328d8c54892358f59685409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f76b66970956c90477e04413d87df51ff77b39017b0886de7ee26fc841aa8afa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57384e9bf27b21e149e8b94ce37db79dd687eb9b4fc9d5301e51c00f235858b3"
    sha256 cellar: :any_skip_relocation, ventura:        "9ddafa7f456eeb9c5731d9d61ff6b19e3987f9ef62b3b44cfb8d0e909ad734ed"
    sha256 cellar: :any_skip_relocation, monterey:       "14c31910f9c5030803f8c8b4140b1a174a063af87f28838c47e97ad3b084a02c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f014b139f2e2257813d574fcad6c6b57a600bdf9f03282a686421ae0c81c21f1"
    sha256 cellar: :any_skip_relocation, catalina:       "bdd7fca0a0fff94b6553d1090b200757aeb2d31755351abe273b88bc969598ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264d7e5a1907af7c51239bbe05c3bf5b293edb22ba06ccdeddd883dab5e14ba9"
  end

  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
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
