class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://garden-rs.gitlab.io"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "398bab121145f71656d0349f99ed77d52534021414818fbd3bb6e81dcd311111"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    manifest_sha256 "f9dea8d2e3c0838e2171a97a0192f802d8c7f3944c90c1f1be98a99ad374dd52"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "740639240bd5ef109e9dc8f74e4affbfb1acee01acd70ff9ca3f86865c00ce65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50d97e80870c0e9a46bf633b8090bbf572670aacd824a03bdb28b89c9417a4c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01464f95040b194fe3e2d8a506eb5d051655d4156696d3c77f8f991ea7b9ffdd"
    sha256 cellar: :any,                 arm64_linux:       "11b6c1396d3736cf4426ab4af88c47731ac21ffc24d5dbf7047f8de970bf86fe"
    sha256 cellar: :any,                 x86_64_linux:      "0d980b3e85755ae4d480437ebf05081ab9a8ca6888f63d36dd71ce8606f18ef7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "gui")
  end

  test do
    (testpath/"garden.yaml").write <<~YAML
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    YAML
    system bin/"garden", "-vv", "test", "current"
    assert_path_exists testpath/"current"
    assert_path_exists testpath/"output"
  end
end
