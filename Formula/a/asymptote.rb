class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.15/asymptote-3.15.src.tgz"
  sha256 "a32764fcfc83eb4eb2981aa9df2c0e6229ffab95929f1030abfc6a6d1abf5e8d"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "ff611b42ed0d2e997e636cc8f35f9d210fd2c2ad50745b66857eeeab0105e82e"
    sha256 arm64_tahoe:       "2e1ca1a23ddf2c4247cdad26aedefa0eded54661b8ee60c2332fba2bdd2b8774"
    sha256 arm64_sequoia:     "4a05b43ae7683ab1864b11497d762e8b154f2c91ffd502ee275a2f0d8756dfd5"
    sha256 arm64_linux:       "e7c9914a3f5df0152248999c600289fc16ba1671f3e428adbf842e3337f34053"
    sha256 x86_64_linux:      "140b6dd260413d7d17de8984b98d3b2255256ca0642c257226ed1f8fcfbb0111"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-headers" => :build
  depends_on "bdw-gc"
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glfw"
  depends_on "glslang"
  depends_on "gsl"
  depends_on "readline"
  depends_on "spirv-tools"
  depends_on "vulkan-loader"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.15/asymptote.pdf"
    sha256 "21248c60a2e5bb80c2dce2d28ef08822a0cc7aa25d1967e8030aea76cdcad04c"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    # Homebrew glslang is a unified shared lib; these split component libs don't exist
    inreplace "configure", 'VULKAN_LIBS="-lMachineIndependent -lOSDependent -lGenericCodeGen "', 'VULKAN_LIBS=""'

    system "./configure", *std_configure_args

    # Avoid use of LaTeX with these commands (instead of `make all && make install`)
    # Also workaround to override bundled bdw-gc. Upstream is not willing to add configure option.
    # Ref: https://github.com/vectorgraphics/asymptote/issues/521#issuecomment-2644549764
    touch "doc/asy-latex.pdf"
    system "make", "install-asy", "GCLIB=#{formula_opt_lib("bdw-gc")/shared_library("libgc")}"

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
