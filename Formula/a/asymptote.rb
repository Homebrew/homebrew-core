class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.91/asymptote-2.91.src.tgz"
  sha256 "ea23b25ecbf4beb766539c821161b4d4c39edffbd8d01f3d9e3fc504a7a3c214"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "f82dd0a6286475861be4e698257edb2e1180fa76f6da868d18a6f19ee0ab8c81"
    sha256 arm64_ventura:  "10777396256202f5fcf099342e3cfeca5fac8a461774b2f6ac2ae3cbde54cb93"
    sha256 arm64_monterey: "f481e2510d0d8a36a619dada0780453ed772aa80c9877ed6b6a9133d76837980"
    sha256 sonoma:         "6003e3c4ac83416e4f4e7c6343defd65933b558edbe697abd4d65e5aa3e8273f"
    sha256 ventura:        "9136bcf3339ce25bf412e4b19c61bf05c8c6d26ca642e21af0ea231eadd9307b"
    sha256 monterey:       "c1cd13b66ac63f1886e816ae943bd780cfeb2061cb3203b5529745a9a6b9cecb"
    sha256 x86_64_linux:   "7ef4b5a522f5813e77fa140cd6ab4c6dcda4ebadddc508c6b88b51437a1f17ba"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.91/asymptote.pdf"
    sha256 "d79e5c2c0b4d4dab7b7fea385cb4b8d44d324ac6cc204aeab1e14e6320887012"
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

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

    system bin/"asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
