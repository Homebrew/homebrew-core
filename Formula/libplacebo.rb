class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  url "https://code.videolan.org/videolan/libplacebo/-/archive/v4.208.0/libplacebo-v4.208.0.tar.bz2"
  sha256 "c89a80655ab375e4809415bb597c638607fc150fa6f6bb830dd502fec7f0ba95"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

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

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/ad/dd/34201dae727bb183ca14fd8417e61f936fa068d6f503991f09ee3cac6697/Mako-1.2.1.tar.gz"
    sha256 "f054a5ff4743492f1aa9ecc47172cb33b42b9d993cffcc146c9de17e717b0307"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    python = "python3.10"
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)

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
