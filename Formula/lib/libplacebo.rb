class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v6.292.1/libplacebo-v6.292.1.tar.bz2"
    sha256 "51f0b7b400b35ce5f131a763c0cebb8e46680c17bed58cc9296b20c603f7f65f"

    resource "glad" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
      sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d39fd06d944a02a6a4524999e97002eb089ad206a5efea6d43d19667417e10e4"
    sha256 cellar: :any,                 arm64_monterey: "fee86a840f4eb479d542ebf23cc2919cebaa038cc655e7bc03cf5a20dba6ee97"
    sha256 cellar: :any,                 arm64_big_sur:  "f9970f6b25f49516e84f773c326533cd895c1a5cdb09870ffefe442df5cd682f"
    sha256 cellar: :any,                 ventura:        "1ece32e31129e380dbb56346ae9498b1e26170b8c184f57f690bf7c0f18656f4"
    sha256 cellar: :any,                 monterey:       "3de6a1292e3389365d91fa4bd1eebc64a3160d39c270ad59b28999f02a5a1357"
    sha256 cellar: :any,                 big_sur:        "b269179f597f0c09a6b3b145b26067fd4301ebfc1233f2871e2ee98e296bf0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0d0c2daaffd9007311137995a02b2d1dc468ef847d51405aa3af865e5ecb09"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers" => :build

  depends_on "glslang"
  depends_on "little-cms2"
  depends_on "sdl2"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      r.stage(Pathname("3rdparty")/r.name)
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
