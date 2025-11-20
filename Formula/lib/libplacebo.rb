class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v7.351.0/libplacebo-v7.351.0.tar.bz2"
    sha256 "d68159280842a7f0482dcea44a440f4c9a8e9403b82eccf185e46394dfc77e6a"

    resource "glad2" do
      url "https://files.pythonhosted.org/packages/6e/5a/d62b24fe1c7c2f34e15c2aa4418a5327a8550fdc272999a59e0dddebc3ee/glad2-2.0.8.tar.gz"
      sha256 "b84079b9fa404f37171b961bdd1d8da21370e6c818defb8481c5b3fe3d6436da"
    end

    resource "jinja2" do
      url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
      sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
      sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
    end

    # Backport fix for Python 3.13.6+
    patch do
      url "https://code.videolan.org/videolan/libplacebo/-/commit/12509c0f1ee8c22ae163017f0a5e7b8a9d983a17.diff"
      sha256 "14ab95f72600c2c6862475838ca5bd498a3a52082f6fdca696473856e503f7f7"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3664b8f58b9d80bfeed7e54efbdca3202a1cff86e9658b10b503bd3ca6c91014"
    sha256 cellar: :any, arm64_sequoia: "4e5f0af5ad2cb7d838cff63d56a50d7db5e9f7ca27c2045a546834397853240f"
    sha256 cellar: :any, arm64_sonoma:  "ad9bf481e31cfd2425500328d11163c3186063233778d07505c854c7bf8b5e71"
    sha256 cellar: :any, arm64_ventura: "84c2732b7169fdc2b799db8e5263f813667b2848742e2f1860a93cf3059e5eac"
    sha256 cellar: :any, sonoma:        "5b7c2f42b54db07a9860001c9d67e767163dea236ac6ebcb19590fb35e04c30d"
    sha256 cellar: :any, ventura:       "15747d8fce1b0d95423e33a7199a8c9fe60c4aa93c05790891094c0ce78853af"
    sha256               arm64_linux:   "8d17bc1d0f2086cd435e9381608d3bb766b4ff959d701108c6eda546d1cea5ca"
    sha256               x86_64_linux:  "3256101be5b4f5ed3d6a449b2d0a5617b013c09e5c00ee5e4276273e8febcdd1"
  end

  depends_on "fast_float" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-headers" => :build

  depends_on "little-cms2"
  depends_on "shaderc"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      # Override resource name to use expected directory name
      dir_name = case r.name
      when "glad2", "jinja2"
        r.name.sub(/\d+$/, "")
      else
        r.name
      end

      r.stage(Pathname("3rdparty")/dir_name)
    end

    # Use Homebrew `fast_float`.
    inreplace "src/meson.build", "../3rdparty/fast_float/include", Formula["fast_float"].opt_include

    args = %W[
      -Dlcms=enabled
      -Dshaderc=enabled
      -Dvulkan=enabled
      -Dvulkan-registry=#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libplacebo/config.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system "./test"
  end
end
