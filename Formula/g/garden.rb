class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/garden-rs/garden"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "86134b51c5adba8688e5e06f5437234694ee7950bbd3e7219501edf9a0199afe"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e347f01f66eaa9e582bc6af516498c6af3a923359e35ea713ebd4ba4e44d77b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46ce400ace29a7079e5196c1ffc90117ed8fbb3ac4478d301dcfb0b0e6acdd04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8590dee00e58ae8d9e4e108e7451f59df55cfae95500deb4d5bf62e24f15469a"
    sha256 cellar: :any_skip_relocation, sonoma:        "81e6dfed5c8130b506350fcede2fe6f6c0d8b46c1fb5c93562b94679348d37b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1709360b691104459b7226b416d2cacf671a52b43fc04bb6cac94fb226d6fca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e217e78e48287a716d8f43befddd2e1e4b0395070ec0f9ba293a682ee7326533"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "gui")
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_path_exists testpath/"current"
    assert_path_exists testpath/"output"
  end
end
