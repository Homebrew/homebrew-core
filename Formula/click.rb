class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.6.1.tar.gz"
  sha256 "2c424337fe760868ade72a96edf22113ad485cf0552f2c38f8259e80eb05e7ba"
  license "Apache-2.0"
  head "https://github.com/databricks/click.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "723ebb70d9304be20e7eb3d047fd2b9c957dd0781c91fdb489163dab92570067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "898f8ee1744e4284fbfa96a4b4b7c27133e6118cb847ded65caeaa93879d2564"
    sha256 cellar: :any_skip_relocation, monterey:       "80166bfa5f6e3521c500ffefcebe28d0e6d69115f4c8789ee74096dc7dbe118c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a8eca14214903976b6257b73fdf466ebe0f45c8c6a07ba1e63b7a84242641ad"
    sha256 cellar: :any_skip_relocation, catalina:       "19ef9ab70df5333e0fffeff3aebb36c93f10fb481573a80b23bbacadd3c49bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a03a6faa6b016e3d5ccd8c17e5d2c730e765ed8a2cf8ee35a86998d02f9c5c"
  end

  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
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
