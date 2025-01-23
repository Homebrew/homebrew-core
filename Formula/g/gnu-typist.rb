class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.10.tar.xz"
  sha256 "f1e79cd95742c84c6d035f6d8f393a2a1be0e00b1c016a22462df16d6667562c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "44219201728a17e0edb4b75bc4092271dac244b8f1465b2e672ce1aed25f3dca"
    sha256 arm64_sonoma:  "23980151c2b8e59ebd60349a5e40cac0ce0bae1797f50014ed116c901a3a43c2"
    sha256 arm64_ventura: "259a69f9a71052547624f9df553d4b0e4e3d96490b40d55f4cc88f00028dd175"
    sha256 sonoma:        "69910310fc08971d9e9381e49bb621f4c263084096f37ed979f67aa5b913db11"
    sha256 ventura:       "f6157fa38bdc20c64fd6127689963537da49f588a0007dc359f4371c498b0c3c"
    sha256 x86_64_linux:  "35ac3380d721aae2bd956a1d5dc935491c61eebda265d3f051ce74b591522223"
  end

  depends_on "gettext"

  uses_from_macos "ncurses"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b5593da4ce6302d9ccaef9fde52bf60a6d4a669b/gnu-typist/2.10.patch"
    sha256 "26e0576906f42b76db8f7592f1b49fabd268b2af49c212a48a4aeb2be41551b3"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end
