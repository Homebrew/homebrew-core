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

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
      sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "736ebf400cf64ccb3b911b8bce2aae416138ee0ad5aebe5ac8d9612c7667d514"
    sha256 cellar: :any, arm64_ventura:  "cf5ed87e4b1a4d627b70f08bb736649c6bf8315888dc0691880b0ff07a48b231"
    sha256 cellar: :any, arm64_monterey: "698a6371c4d7cb241086f1c11752f7aa89971b65be2c4cd7cc92d8706c3acaf8"
    sha256 cellar: :any, sonoma:         "0e482f5fee32e6457a98a7087b31633416d019dea39cc4e6c8faffe19d1f5d89"
    sha256 cellar: :any, ventura:        "b6bc76ba1a84e0490d60fd68516cd9f23b31e2b4400846532c2b93dd70bed75b"
    sha256 cellar: :any, monterey:       "3e35416fda4cc537ecc2e6e79e61e3a27d522108a23d95e12ada28c9ca065ade"
    sha256               x86_64_linux:   "b8764ef84438c4c71e88e80da835593a5112b94a0a57091401b0843609a641da"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
