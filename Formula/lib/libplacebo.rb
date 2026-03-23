class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  url "https://code.videolan.org/videolan/libplacebo/-/archive/v7.360.1/libplacebo-v7.360.1.tar.bz2"
  sha256 "937aa5eeea596798b3274d362de2e3bd32bc537a66d149dd85043349c74dffb6"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6575f7e22f75c946f5c831d2ff130b89aa275a2cdd4dbe7a0204590513b87b25"
    sha256 cellar: :any, arm64_sequoia: "1fd6531a9de50d0121d1ff4ec67163dfb1dcb8c682d96c6587b960f04be0fe34"
    sha256 cellar: :any, arm64_sonoma:  "8b89e9ee2c276bded52d69bbfc3b645625c975e9edc3ba93873c18d661ef241c"
    sha256 cellar: :any, sonoma:        "a6a5f1fefe34a81d3fde35cdab8481899afc47b90efff12b912b0b1675f90861"
    sha256               arm64_linux:   "b87acf6094dc3a89d9a942259ae453fec22a770aa3fab05dba2e3c2c71702558"
    sha256               x86_64_linux:  "145b3ac56e39a1a925671872f5ec1176c568d518c643cf689ae66f33494d43b7"
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

  resource "glad2" do
    url "https://files.pythonhosted.org/packages/6e/5a/d62b24fe1c7c2f34e15c2aa4418a5327a8550fdc272999a59e0dddebc3ee/glad2-2.0.8.tar.gz"
    sha256 "b84079b9fa404f37171b961bdd1d8da21370e6c818defb8481c5b3fe3d6436da"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

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
