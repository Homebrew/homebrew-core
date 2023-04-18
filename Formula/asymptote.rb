class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.85/asymptote-2.85.src.tgz"
  sha256 "4c0559b62c41f947b5fbf044b4d091bd3cf0abe599c85138087069809875ec87"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "4c6ed796d51ad30c269d64e62ba8154365420ad2e833eec0422a365d17946a39"
    sha256 arm64_monterey: "907d5066c8bf3c9eff2cf6c18b9516387a611f22f78629072a44a448b9655c9b"
    sha256 arm64_big_sur:  "c54e0cb0006e56aa4f9d061112cbcf3ca7da9b8eb2a86bfcd226abfae6592fca"
    sha256 ventura:        "8660647d677ade7c8005a97413a2308cfae40644fc515a4cd7a2409ab5aecefb"
    sha256 monterey:       "37852200460bf4eeba74782b831531a5857a9fa74442b34a97ef05b2a3675599"
    sha256 big_sur:        "10381108e5b5f8d84243c9061d76044e179af9476d51d88458409ddda7b64746"
    sha256 x86_64_linux:   "a442cc9eca515335e9376e7b51a87ba53a9ea25dda713e1676f0d877844c89fa"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.85/asymptote.pdf"
    sha256 "fcc4fd1adbb73347bd731f0bcf8c206a55acc65cdeb8e2aee74611230778cfef"
  end

  def install
    system "./configure", *std_configure_args

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
