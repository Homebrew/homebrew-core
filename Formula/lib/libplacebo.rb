class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v6.338.1/libplacebo-v6.338.1.tar.bz2"
    sha256 "66f173e511884ad96c23073e6c3a846215db804f098e11698132abe5a63d6f72"

    resource "fast_float" do
      url "https://github.com/fastfloat/fast_float/archive/refs/tags/v5.2.0.tar.gz"
      sha256 "72bbfd1914e414c920e39abdc81378adf910a622b62c45b4c61d344039425d18"
    end

    resource "glad2" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja2" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1c42d1327983e90d82f4e077e8bf14c7afae01c95aae6113b7a3f371b9ac4bf"
    sha256 cellar: :any,                 arm64_ventura:  "e6a5759fbca2ef6e6004b6a2b7e356d84061e8723559d0f56ecd0f46dd86f67f"
    sha256 cellar: :any,                 arm64_monterey: "886b67b276e0c879a497b20826f8d5377cfefff60d88ecb5cb71816a53d40957"
    sha256 cellar: :any,                 sonoma:         "d35b66c02f1933b3723b2531075aa6a28df8c18ba16fc4bf0067039970a7e2f1"
    sha256 cellar: :any,                 ventura:        "88deccd1f3d40a6449b6f71467168d1e56c0a85c30e282042b610783aeaca4e1"
    sha256 cellar: :any,                 monterey:       "820949127d8d376762ce0c3184e2a63ad85eb55da68b8bafb98ebd9a5a44bada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1fbe78408554a619163e3a09961d95cab0ce22b445ae47583b65edec9e44463"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers" => :build

  depends_on "glslang"
  depends_on "little-cms2"
  depends_on "python-markupsafe"
  depends_on "sdl2"
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
