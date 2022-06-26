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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6018a93852c7b6c6ae53f2a3455204097ebec31a91ca05dfffacb2225dedda0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73605f74a8092b5f43b7586ac4378dd69171fd893d4b5beae6ccfdbe060774a7"
    sha256 cellar: :any_skip_relocation, monterey:       "aa42b7e95d2d152980c34fd99b97d4a3dcf6672eaf1637a4fb6bf0328d942317"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5c6c86904815ded47f80fe83eec3b45855be124440654bf6f0280f9debaf2e"
    sha256 cellar: :any_skip_relocation, catalina:       "08087704f1006723aa1be837898c210715ff3399feef94b8138611a097858eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb77229d9f818ca7ba63e9a266caf69d2c745e8603acf03e52d88d3e0ce2e67"
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
