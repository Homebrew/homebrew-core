class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "3a50b66b888754047931969d9a1fb84178406b638c183a387a58deb48529776a"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb1bc0263bc8da3aa0bd69a2665c5aabb9b423b333f52a1249597e0911e96eb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714a45038bc2eea879d55859ce88e300076ad684eda9638893fbac1a3d2e3e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5899d2af9dd54842d8b682299ee00c30ad4c9f0e0ce85540323956f83c99cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6df8796639c101a2eda752ebc75c50a5fffbd6bf42b416a9966fc58dc856f5d"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    (testpath/"test.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" />
      </svg>
    EOS

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_path_exists testpath/"Icon\r"
  end
end
