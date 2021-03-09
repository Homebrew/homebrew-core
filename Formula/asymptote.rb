class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.69/asymptote-2.69.src.tgz"
  sha256 "466456077477f9593785af41fcc45bb9a1c0253b40796982d78bf2c7804df79d"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "5bc32ee475579206caed260136147e6bdf78033ae6802869610f0a819a8d3aca"
    sha256 big_sur:       "1fca67852324d36dcef54330e3fff2dc63cfab1febb181fe32331fab68e3b1dc"
    sha256 catalina:      "eb767b712aef26dbc03011b252816a75d11cb1b3f4d9283a8d5c471f107b321c"
    sha256 mojave:        "93bba0f8c39057a76fb2d5bc13aa8e67d0b7a6ee831d26b70e3b23f5521672ea"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.69/asymptote.pdf"
    sha256 "d87538cadf1af08ef2217165de6b88b0520eeb67a9e5f1a6bb8f9e3f67e09704"
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
