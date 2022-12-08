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
    sha256 cellar: :any, arm64_monterey: "3f113d415c26bf237f93941a74496fa9a0895f95391bcbe7d40979c4aed51ff8"
    sha256 cellar: :any, arm64_big_sur:  "f59770598c4b472ded9c4a7dba4940abbe329e06d4a2ddd6321cb1428f5c3316"
    sha256 cellar: :any, monterey:       "19852df5a17236a60a765dce3dcb06854349da6a9761384e0df3a27ffa811e98"
    sha256 cellar: :any, big_sur:        "93c1e3ea5040219a5498b1140481316a81c7424a2fc1a8cd56d361dcd3e2c667"
    sha256 cellar: :any, catalina:       "cd55187c55c1bee4be2420bf092a60b541550727263ac717ca5030a898492bc4"
    sha256               x86_64_linux:   "98ca562ff165a97fd38574ece4987534ef15deebfe3e9e945159ba9e2dddd45a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
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
