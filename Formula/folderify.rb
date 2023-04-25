class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v3.0.11.tar.gz"
  sha256 "c87fdb59054a3c7e96242b096e9b05fb120043d30217070df9c526507e6c14d1"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b081d72034422d768d058dac626d3e5066bd1089dc2ae524c0d88f237f174387"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7991f8d0323a9e8856bf837cc2bdb09fb303686df7c6df27b1f306fd9bf1390d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34caef3fafe1d279100e570b26bc9c0ad5f3dd35adb84a055c91d180a509acc0"
    sha256 cellar: :any_skip_relocation, ventura:        "471bd024cd96ea5a590514bb6e97f4cc5c8ccf17903b1278804eb8f58e6d3bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "28aa23d925c133176172ad0ef1faeb8e2c78254989f76956d9409377974bf461"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2a194248e46b6c6a6c83a71190cb756c1ddf9a97ca678a4b5d1ec7b0d4b94fd"
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
