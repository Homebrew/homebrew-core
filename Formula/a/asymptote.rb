class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.14/asymptote-3.14.src.tgz"
  sha256 "491d5e87299d48976b193beaac2621ee76c9b2058a597b332dc455962d82de97"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "336f94a1d5d94730e09b23c69fa3739c93d66cae8fd5a41df3deeba898c9fc69"
    sha256 arm64_tahoe:       "0dce045541fd4669ddb683988d9f413dccfc2cabd0e6c0d394260068ddd1c108"
    sha256 arm64_sequoia:     "98daf9029759d98c3ed6e081483d9a1ba3ce43cf995a957e9e07f09b9f2a3642"
    sha256 arm64_sonoma:      "c72515a775d6206feb4f877fd665757d4062b7794049233c00814db8111a4e65"
    sha256 arm64_linux:       "4d40b2b891f9bd92b70aa3b9201db55eccf5e920ff7df5d186152e667c119d2b"
    sha256 x86_64_linux:      "22ed9897a0aa8b0e7b9de3136246c18ee8aa5eb6d7c9c99e83742de3bcce0a5d"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.14/asymptote.pdf"
    sha256 "1a25e2064899c8fd2582ca9d37198c2817d8b57f635426420ea6b0b8bd753ff3"

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
