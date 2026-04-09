class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.10/asymptote-3.10.src.tgz"
  sha256 "d27be8fef250d5dc338602bf723e1d09e8cd1e85c199ab4c80743089fd8cd2c7"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ea07bd3a67f0a778633e27c0e65860276f6a2789e13de6f6193eac460fe23b8b"
    sha256 arm64_sequoia: "d4d6ea976e1abe6fb34061edb0aa8a06bb05e09173ca4bd083e8abb463264b06"
    sha256 arm64_sonoma:  "269b025c6c9ef948565f34b5250b5baf763a3ff029c3420da3cd8559240a89f8"
    sha256 sonoma:        "23ae94864d03ed420489af9acb41627b75f3bdca6506d80b67b280002813d1e7"
    sha256 arm64_linux:   "075da15165b811225aa07c7ca3b6883216c04d86754067545b2b8646b10b2a09"
    sha256 x86_64_linux:  "398bb6270a3eaad7961ec5f80229148c86f1361c2ab6da511c5ebaf4bda02db7"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.10/asymptote.pdf"
    sha256 "4b8d393fbbb0b44942aa3d70ceb7534e091c4eafe9946dc01667868f612c208b"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system "./configure", *std_configure_args

    # Avoid use of LaTeX with these commands (instead of `make all && make install`)
    # Also workaround to override bundled bdw-gc. Upstream is not willing to add configure option.
    # Ref: https://github.com/vectorgraphics/asymptote/issues/521#issuecomment-2644549764
    touch "doc/asy-latex.pdf"
    system "make", "install-asy", "GCLIB=#{Formula["bdw-gc"].opt_lib/shared_library("libgc")}"

    doc.install resource("manual")
    elisp.install_symlink pkgshare.glob("*.el")
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin/"asy", testpath/"line.asy"
    assert_path_exists testpath/"line.pdf"
  end
end
