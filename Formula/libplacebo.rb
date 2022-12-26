class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v5.229.1/libplacebo-v5.229.1.tar.bz2"
    sha256 "fef7000bd498921c2f6eb567a60c95fbb3ea39ff0a3d5cc68176eb27b5dd882c"

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
    sha256 cellar: :any, arm64_ventura:  "f836c0f2d72ee350cafc1ed9e3c7dcb0004ea8a5f23dc1a7b772a200a7ee6bb8"
    sha256 cellar: :any, arm64_monterey: "82dfb4d29e647496897ec8f45e44e61574ead9e0d2e07e0d223d374286492807"
    sha256 cellar: :any, arm64_big_sur:  "02d1c68e4e70cca3f800fbd457544f10f9311e3acb034d6f2323ed19af26b65a"
    sha256 cellar: :any, ventura:        "c4972dfcf3c91aec6789ae40a131e15835e7f02a10f459db1b3058c225256c7b"
    sha256 cellar: :any, monterey:       "739c011349ca2db7198d0089a0896e3b10c40ef8609273852e7385ef3aa98d49"
    sha256 cellar: :any, big_sur:        "a668ac54f239149f53b810577d955a06a26211d91cb582f406cb9ed04f2306e0"
    sha256               x86_64_linux:   "197511f3a746307cbf11249f9f26dd7ae47b8926bdb9843d6f3c89b75e7d571d"
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
