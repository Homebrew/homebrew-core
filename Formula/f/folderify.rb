class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v3.0.12.tar.gz"
  sha256 "5979fe57e1844c9b2499003ff39c1598210969235a8733766034aef266b02ff3"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a13ee77fcf36dab544fa11ac4aa70a6a5da5c162b8c30a1cfd3d29d7ab566aa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23dcb2cb9e5dfd0db50e67dee1da1cfbef42c53422447d2b28874d1519f8d2b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90de5e21ae722a34bd83716da6568251352326f9f06fda6da8cf94f7fa4a4c80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a171d3b67b425d57e098c96f9547de9b6190a8e83c320fcb21cc9860c4e37480"
    sha256 cellar: :any_skip_relocation, sonoma:         "daececb909d8d76b98356a33a7ae53a5a9ad922e26e48fc24df7160a2faca87a"
    sha256 cellar: :any_skip_relocation, ventura:        "511dc96bac985c7c4373be840e1cc1426cb166e596031e4033733e01cc7523be"
    sha256 cellar: :any_skip_relocation, monterey:       "02555b1c34b184754d01e0ec2320537e4d2e8c759e2db72d2f5ea220dd2c3e78"
    sha256 cellar: :any_skip_relocation, big_sur:        "73512b04cf5d3d39f501bc621b9c5f1c0704a21428824087343c8c1fd816bd08"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" /></svg>')

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
