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
    rebuild 1
    sha256 arm64_tahoe:   "a1e24aadd965c62d63a7d54a252caefa87a7fec04d5963ae0c120403b3dc7b74"
    sha256 arm64_sequoia: "9197758006b6a9b420df80bb3c1e07a75e7f40d86f4b96ac8f9252df45ab9bdc"
    sha256 arm64_sonoma:  "af2e2ddb5fe6069c01ef132aa5198d96899f45480f6e116eff6c2c395cb0a654"
    sha256 sonoma:        "72578bffd30aa433b6274c7d7de50ab6be542a7cc256604f18c4a92c4eab58e7"
    sha256 arm64_linux:   "a7089b64c4a177e4b387f264ca2ad93a4865a0a6b09e0916116478169ef3e284"
    sha256 x86_64_linux:  "46348f668186d113647bb29e0018e9ffc839b1c4fd482f7bb8cff588b002aab8"
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
