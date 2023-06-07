class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https://github.com/mklement0/fileicon"
  url "https://github.com/mklement0/fileicon/archive/v0.3.4.tar.gz"
  sha256 "c5673cafa9479eb1c3ec312e6673b912bc1630b361732da137428859e037dd91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98e8ac6732cde1d52e2579d3fddd9a87bd03547fb7a4188dd7f9c95498caf487"
  end

  depends_on :macos

  def install
    bin.install "bin/fileicon"
    man1.install "man/fileicon.1"
  end

  test do
    icon = test_fixtures "test.png"
    system bin/"fileicon", "set", testpath, icon
    assert_predicate testpath/"Icon\r", :exist?
    stdout = shell_output "#{bin}/fileicon test #{testpath}"
    assert_includes stdout, "HAS custom icon: folder '#{testpath}'"
  end
end
