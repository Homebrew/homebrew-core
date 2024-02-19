class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v6.338.2/libplacebo-v6.338.2.tar.bz2"
    sha256 "1c02d21720f972cae02111a1286337e9d0e70d623b311a1e4245bac5ce987f28"

    resource "fast_float" do
      url "https://github.com/fastfloat/fast_float/archive/refs/tags/v6.0.0.tar.gz"
      sha256 "7e98671ef4cc7ed7f44b3b13f80156c8d2d9244fac55deace28bd05b0a2c7c8e"
    end

    resource "glad2" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja2" do
      url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
      sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7839601c57d0ceae5967ae877e8910cc6f2ceca9442878180f62c549e76fdd07"
    sha256 cellar: :any, arm64_ventura:  "990a5225915a2069b94c2a34b98de62ea85e2ba424ad7d89301db9b294b37cab"
    sha256 cellar: :any, arm64_monterey: "80a00f7310cc09d2baeba680dcef81f348704c876430324467c1339088b8417b"
    sha256 cellar: :any, sonoma:         "3035517d9bc264dd0757523fbe76d6a85fb5a2294ac5d7522335c4c5622ed9ff"
    sha256 cellar: :any, ventura:        "7482dab3cc6a3d6303e8db7fde241e73b489d6b41c940c0b312409764be2b436"
    sha256 cellar: :any, monterey:       "feb5e92bf7fbae0950b4b216bd744c47ed544cc04e1cb0db5587f9179eb83c96"
    sha256               x86_64_linux:   "507aa688bf4a70eb4b5c33f35e10efe8a3f79acd22ba705ea7cb77381e0de7f2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers" => :build

  depends_on "little-cms2"
  depends_on "python-markupsafe"
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

    system "meson", "setup", "build",
                    "-Dvulkan-registry=#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml",
                    "-Dshaderc=enabled", "-Dvulkan=enabled", "-Dlcms=enabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libplacebo/config.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system "./test"
  end
end
