class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v5.264.0/libplacebo-v5.264.0.tar.bz2"
    sha256 "361c2936b0c9d18ca4a56a7aee63f91f3024c3206f72d42205ca58ed941e0c6b"

    resource "glad" do
      url "https://files.pythonhosted.org/packages/e5/5f/a88837847083930e289e1eee93a9376a0a89a2a373d148abe7c804ad6657/glad2-2.0.2.tar.gz"
      sha256 "c2d1c51139a25a36dbadeef08604347d1c8d8cc1623ebed88f7eb45ade56379e"
    end

    resource "jinja" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
      sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b05f2f221207a72eb0aeff0e9e37b8d1f4e835e159a0a2bb36d7acddfe9c2ef"
    sha256 cellar: :any,                 arm64_monterey: "c0e4a6375bc8fd2d89247a4bbc6c61dbf48253610d02e3ddc1d5c12668c84724"
    sha256 cellar: :any,                 arm64_big_sur:  "ad4989d3cbbce00f7e8bcd9fc83ee2c7251e7badba15d488871d70736e962867"
    sha256 cellar: :any,                 ventura:        "246b9d7683c435ba28de917fb9de6fbce3f21922a4a3654ddd8baac1bb925dec"
    sha256 cellar: :any,                 monterey:       "bb3746c338f7c079f537167689761fd626dbee20fa668625e2729e56f3cbe876"
    sha256 cellar: :any,                 big_sur:        "67b2935367bd5517deea483e4a1289240e5a1ec47c46ecf788ae95a0819cac00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b5a9b11c0861b7bd23b547dcaf36648194ab4062d639428ba7500791653deac"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers" => :build

  depends_on "ffmpeg"
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
