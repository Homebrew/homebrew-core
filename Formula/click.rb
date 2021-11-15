class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.5.4.tar.gz"
  sha256 "fa9b2cb3911ae8331217cafb941cdee52b09a27a58a5dccbdb52f408dc22f4f4"
  license "Apache-2.0"
  head "https://github.com/databricks/click.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08fffc5fa5f08e292d5ebb07ccbd3d8cfe2b7ec70d06420377c94e849b4bc3c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e54fef33b234b0c5053040a012ff0ab1c548ff31dfe660e0f577b01cd6727ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "c96d461641e892fcf31ce73d018abc1910a479c2d715521dda44c5f2867baba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa74cec2f0d6854791b46d54adbdb96bff085b67278629695f0ac266eef54717"
    sha256 cellar: :any_skip_relocation, catalina:       "59c72a4b00a3bf477cd3d65573175d6009112273b715b30d49be7bc694fdcf80"
    sha256 cellar: :any_skip_relocation, mojave:         "b7f4b485ff0eb502694555d0f85096880e6a0355b7e69adf2bb5075d2396ade1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553af140b3e4382834691f12fba51f61640eee9aa35ed2db8a20732a6ccd9488"
  end

  depends_on "rust" => :build

  uses_from_macos "expect" => :test

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
