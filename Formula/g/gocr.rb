class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://jocr.sourceforge.net/index.html"
  url "https://web.archive.org/web/20250919083502/https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.52.tar.gz"
  mirror "https://fossies.org/linux/privat/gocr-0.52.tar.gz"
  sha256 "df906463105f5f4273becc2404570f187d4ea52bd5769d33a7a8661a747b8686"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a46d3d1c4af1c44bfe397a9a03e6e8cc2de136e6fe19a277260d901a13c52b61"
    sha256 cellar: :any, arm64_tahoe:       "cbd973c1b8777dc10907bf3ef89def34faa6ddf4c7e6f618cf05a2d271fba3dc"
    sha256 cellar: :any, arm64_sequoia:     "5a3ae91a8c0eb89b304af4c532774057498b8fe0955ea1631c824329e9a48b67"
    sha256 cellar: :any, arm64_linux:       "88eb3668a823d43b3c50ab1bfb7054b1d33cf400a6af9de8b8f8b049720a92c4"
    sha256 cellar: :any, x86_64_linux:      "3afbb5a8810d9aa759503415fdd0beb83cd2bbd090a660d8e322aa96179c7ce3"
  end

  # Upstream homepage is gone
  deprecate! date: "2026-06-22", because: :repo_removed
  disable! date: "2027-06-22", because: :repo_removed

  depends_on "jpeg-turbo"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch do
    file "Patches/gocr/0.50.patch"
  end

  def install
    system "./configure", *std_configure_args

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system bin/"gocr", "--help"
  end
end
