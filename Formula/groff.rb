class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.4.tar.gz"
  sha256 "e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "1e46ef402875ec8cc1bc1fc05b748607822ed6c2a58508dc83d3f0c8cf7f5c4e" => :big_sur
    sha256 "f273750ee87dd64d4ae3ec08f3f6ac83a5e15eb0c2e08f9ebaf488bf9a739f96" => :arm64_big_sur
    sha256 "623edd28279abd071901f92502fd3a388aaf4357113f26b37ee715a9d11d05ab" => :catalina
    sha256 "4fed5ee8032eb7957bd964b0eb873f8954a4d427f0c602284992daca52e7cb6d" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "netpbm"
  depends_on "psutils"
  depends_on "uchardet"

  uses_from_macos "libiconv"
  uses_from_macos "perl"

  # See https://savannah.gnu.org/bugs/index.php?59276
  # Fixed in 1.23.0
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8059b3027a4aa68d8f42e1281cc3a81449ca0010/groff/1.22.4.patch"
    sha256 "aaea94b65169357a9a2c6e8f71dea35c87eed3e8f49aaa27003cd0893b54f7c4"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x", "--with-uchardet"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end
