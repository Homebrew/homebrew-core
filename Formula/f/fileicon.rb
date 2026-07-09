class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https://github.com/mklement0/fileicon"
  url "https://github.com/mklement0/fileicon/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "e0b64fb5ead02dc74fb097948aaca2931e61064e8177801b08a6b57d263cda7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f949b99b0a677468c315be200854ef1480a72e225a3f3cef028504030389a62e"
  end

  depends_on :macos

  def install
    bin.install "bin/fileicon"
    man1.install "man/fileicon.1"
  end

  test do
    icon = test_fixtures "test.png"
    system bin/"fileicon", "set", testpath, icon
    assert_path_exists testpath/"Icon\r"
    stdout = shell_output "#{bin}/fileicon test #{testpath}"
    assert_includes stdout, "HAS custom icon: folder '#{testpath}'"
  end
end
