class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.13/asymptote-3.13.src.tgz"
  sha256 "24b2d2fdfa1e25382c0fe84e5d79466f5ae369d7d9f8d99ee2b9b64fa11dc00c"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "0c784ca0b04674284390e0bd5f49870c7cdf06c316a48e2714858fc53f919c15"
    sha256 arm64_sequoia: "1d3f03293332515421696c7b4cabb2b140589218a360caee77526a3c07e80268"
    sha256 arm64_sonoma:  "c7c05272a454ad156b8d73e1d61518d0b2a2e0d9ba5992dbde2242d2e78960cc"
    sha256 sonoma:        "2094c489fcc8cad9b9850731a4397ee8c1a6f9c81517e40280d8a96871e32300"
    sha256 arm64_linux:   "5664de360bbfe4bfbd3fcad2b20ac2d3553d5559271eb7e01c526a5fb567c7f2"
    sha256 x86_64_linux:  "f901cdf326dcadbcbc155d2bfa9bdb149d8501f34776bd2b41f3abe5ac216b3e"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.13/asymptote.pdf"
    sha256 "19f55817da70ee2925f4c166c9936b9cabafff24399f9075d3bd48edacb9d178"

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
