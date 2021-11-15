class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 3

  bottle do
    sha256 arm64_monterey: "f47658e3c308e214021ce37684fbfe76c3ee9924557410e82ff93e52a59a1ff3"
    sha256 arm64_big_sur:  "8a0195117bbc39e675d17c3b7fd0015cccd13c98be46d47e6f56e027b666d571"
    sha256 monterey:       "b431d8e24b0742d297aaf850066c097f4db5ab9db4a752d3c36e72663bf508ec"
    sha256 big_sur:        "9ccd086cd3885b5eb3b82459902f3a52516019d833a83f0253036c9eb3a34dfd"
    sha256 catalina:       "391af03b52dcc608abc5d796b9dd517ac1a5c3b70c56dc1ca5264003fe8643c6"
    sha256 mojave:         "e77595f6933d861063bbd5c91a668abb9608434f777f4c8e8c2bee99eba1e102"
    sha256 x86_64_linux:   "18788da5e0deb12b17cb6b08c9633825e69f60c7ed9206f34dead33b77ecf144"
  end

  depends_on "emacs" => :build
  depends_on "libffi"
  depends_on "libtool"
  depends_on "pcre"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "EMACS=#{Formula["emacs"].opt_bin}/emacs"
    elisp.mkpath
    system "make", "install", "emacssitelispdir=#{elisp}"

    elisp.install "gforth.elc"
  end

  test do
    assert_equal "2 ", shell_output("#{bin}/gforth -e '1 1 + . bye'")
  end
end
