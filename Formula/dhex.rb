class Dhex < Formula
  desc "Ncurses based advanced hex editor featuring diff mode and more"
  homepage "https://www.dettus.net/dhex/"
  url "https://www.dettus.net/dhex/dhex_0.69.tar.gz"
  sha256 "52730bcd1cf16bd4dae0de42531be9a4057535ec61ca38c0804eb8246ea6c41b"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d6043ce881b7b407fa40691639c25c72d73a427fcdd39a56e0683f48b16b328" => :mojave
    sha256 "bfc2aa6c73ffff61a471b4dd8e183e493781a5c34baeddffc56fa89b0542a9bd" => :high_sierra
    sha256 "b83e63ad0f1e2910e1f2495903ac4077aa5caaabe8cb2702094f42c3921c7a9c" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    inreplace "Makefile", "$(DESTDIR)/man", "$(DESTDIR)/share/man"
    bin.mkpath
    man1.mkpath
    man5.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    assert_match("GNU GENERAL PUBLIC LICENSE",
                 pipe_output("#{bin}/dhex -g 2>&1", "", 0))
  end
end
