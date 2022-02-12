class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https://github.com/mklement0/fileicon"
  url "https://github.com/mklement0/fileicon/archive/v0.3.0.tar.gz"
  sha256 "d4835a940bcec7cf5bd4531dab6062b04761d7bcfc328bf2599400b24015d0e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "351fd94a479c755b17d874a82eba7986842aaeb57e8b6d65c4aee3b1b5434f32"
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
    assert_includes stdout, "HAS custom icon: '#{testpath}'"
  end
end
