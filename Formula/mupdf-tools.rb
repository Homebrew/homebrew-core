class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz"
  sha256 "c443483a678c3fc258fa4adc124146225d0bb443c522619faadebf6b363d7724"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9b9952ce57aee95995948164bab35e111a86e97be90be9daec06b4da9dc2e95" => :mojave
    sha256 "aaeb5b84d303ddac285b08e1508d1ec7c51327e9dd51c878d45002cff348c1ba" => :high_sierra
    sha256 "e2784582c73bea831d1a23fef44e0b792fa073fe4ec9d0494b0f72a894e3cdd1" => :sierra
    sha256 "e4d44153713cd6029d9ab609d745a7a3c7984e532ababf5311280c319ab4ca99" => :el_capitan
  end

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{test_fixtures("test.pdf")}")
  end
end
