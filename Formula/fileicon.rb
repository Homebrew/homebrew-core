class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https://github.com/mklement0/fileicon"
  url "https://github.com/mklement0/fileicon/archive/v0.3.3.tar.gz"
  sha256 "093cb8d0a0efd1ab1463309953c0e906136c3e31396736ee3c3af3ba45a01fd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "128446c8e98b25bf0e92168aee7e2c15e29eb8b517f6d83bc04308d6f66f588e"
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
