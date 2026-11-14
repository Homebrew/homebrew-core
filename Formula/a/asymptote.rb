class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.16/asymptote-3.16.src.tgz"
  sha256 "3755e8f3776a3d494354964ba0109203eece417ccd8ac8f5479932514cb30e1b"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "15f2e324377f4f3c8cf2ccdf645a2fc1df4e4ae836c21a01592e242b25f83760"
    sha256 arm64_tahoe:       "cc599f37c6eedeee835f0ac1778faae4483f7b755e2c1eaf5668f8e374877372"
    sha256 arm64_sequoia:     "b7d28ddb24746f7a1733f09a1fbb6d27f3bb4f75deac0cf6f95a39ced47de009"
    sha256 arm64_linux:       "f7a39373b7c72b7e0d1404782ddbe735aa5e42b6a6ec9869779fe738b1dc095e"
    sha256 x86_64_linux:      "3ad371288a96f51ec82f04169353123fd7eac5bff42dc02b36710634f71d5988"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.16/asymptote.pdf"
    sha256 "ea1f2a5af6963da29cf77aa52b1280e29396fe2c9fda11a4cd4049440f3bbf82"

    livecheck do
      formula :parent
    end
  end

  deny_network_access!

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
