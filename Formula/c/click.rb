class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "da64d1d205b6136f318dea967eec4e9d67569be8f332875afcc6b31c9a0ef1b7"
  license "Apache-2.0"
  head "https://github.com/databricks/click.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "96815f530661c69c118a128df96453746171c7f504e63d55d9ddf03baf1c6dbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e987eede7eef110c096c8093ccfbf321f3835378f8a65619627eabe348e0d985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aece6aa76034deb2d8e1437d85f4e4c94195de67eb7948d19b2fc2423824808c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a828f3d797aa3aca5596984e8b8f51afdbe123c3f8e7fa4fa6e760f66a4e57e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902ecbe1a647d12fe9fa8fc5de1e6c0336e8f4d1b979c24c71da8ee0c446ee14"
    sha256 cellar: :any_skip_relocation, sonoma:         "14315013a9e3ecd0882de00d7d5d25588e0d3ed6d098d23f61a1714e93effa39"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e56cb51e4c684096a2f9c2fbc736423e2d0b38a96f6f423d0d269a149fb66b"
    sha256 cellar: :any_skip_relocation, monterey:       "db3b2aed30f0a4b6cf38f1834d3710ba051a8cce3d3e6bb2ee895b2493e4b30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4b49f975c698d3f29c6055c055b11661315b87e270fe773604fe24902cee603d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b30c2c15da3c503a541a5f751928abf68496261df9374a23c6d5dce58b9d2b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Default state configuration file to avoid warning on startup
    (testpath/"config/click.config").write <<~YAML
      ---
      namespace: ~
      context: ~
      editor: ~
      terminal: ~
    YAML

    # Fake K8s configuration
    (testpath/"config/config").write <<~YAML
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
    YAML

    # This test cannot test actual K8s connectivity, but it is enough to prove click starts
    output = pipe_output("#{bin}/click --config_dir #{testpath}/config", "quit")
    assert_equal "[\e[38;5;9m\e[1mnone\e[0m] [\e[38;5;10m\e[1mnone\e[0m] [\e[38;5;3mnone\e[39m] > ", output
  end
end
