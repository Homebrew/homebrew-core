class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.06/asymptote-3.06.src.tgz"
  sha256 "5cc861968fe8102fc5564b6075db2837dd5698672688b3bfb71406c0da0f8cef"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "814b188f28dd593747d45a1a2a9f59011cdf0fc3a7d121d053e3109ee5649311"
    sha256 arm64_sequoia: "2326f3949c22f1bd00df59c0ddee388e06e58ddd164cbfbea87f7033bf3f7aab"
    sha256 arm64_sonoma:  "7a6a49634130032a12c0100df37300fa6cbb9fde874aac00204539db78005f38"
    sha256 arm64_ventura: "d4a00b288fa17bc6f556ac79d2fde894369181cad7edd7c81e79ea26499a3a3f"
    sha256 sonoma:        "53cf893a46148dbea3304ccc0eda5e64a56eda39a25bbf7dcf4e34428ae7eb30"
    sha256 ventura:       "8aa6f5d28d73efc11ceb4cf3ebddae9be8472095505fb103080c1f0bbcb251fd"
    sha256 arm64_linux:   "e1e896e59e89d3dbd32de5c717ba417e99b4cd6f11201a236319ab7a2d392f2d"
    sha256 x86_64_linux:  "61d615b53a3d74f89ab4338a1cfaca6df53602baba4cec6b89541568716d9905"
  end

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
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.06/asymptote.pdf"
    sha256 "dfcbd9f300a4bb9ef21ab5ad150fd22dbaeacbe1d710f1ae0288a971ffbdd9e8"

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
