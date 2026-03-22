class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "10bc181d282ab99143178e9b6d23da46b216aef200f3ec282c783ba0d4e666b9"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91b9dff20bd5ab363fbd573dadf35f0b78410dfb275e77e3d77c1e424fa6cd3e"
    sha256 cellar: :any,                 arm64_sequoia: "0dccef8a0abe4b6f56b63b16fab54058316deaf28c6b5af3360214fee7750c0e"
    sha256 cellar: :any,                 arm64_sonoma:  "f057ac1b33b63704e23e9d62431e4925d9995df18fb064adc3aa0e48d2662bac"
    sha256 cellar: :any,                 sonoma:        "7fe04e7f88a301551cf89a98f82e3178536c1b12b609bf9a846b06f10e3437df"
  end

  keg_only :shadowed_by_macos

  depends_on xcode: ["16.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :tahoe # Swift 6.2

  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system bin/"trash", "--help"
  end
end
