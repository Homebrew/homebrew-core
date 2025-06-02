class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v7.351.0/libplacebo-v7.351.0.tar.bz2"
    sha256 "d68159280842a7f0482dcea44a440f4c9a8e9403b82eccf185e46394dfc77e6a"

    resource "fast_float" do
      url "https://github.com/fastfloat/fast_float/archive/refs/tags/v8.0.1.tar.gz"
      sha256 "18f868f0117b359351f2886be669ce9cda9ea281e6bf0bcc020226c981cc3280"
    end

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
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "cc68b84e986ff3921494c0920a263504caba9179d16cc360e2bf85b67f0da03a"
    sha256 cellar: :any, arm64_sonoma:  "1d95abadbb00238446545c61ae7f78f130b45573d583da76bd12605765ae1320"
    sha256 cellar: :any, arm64_ventura: "e79f218b3c019489133386f735faa8b2993ca08804b71e0c42cb95805f921d0b"
    sha256 cellar: :any, sonoma:        "a06adea720f3c7c7b03f1f0e6e56c0ee137c68c89b9579e7e0c6ad786a3bc49b"
    sha256 cellar: :any, ventura:       "dfe66fa848bafa93492c8613690a84efe7d95a3c246d2e33fb99d6b1d46bf0f4"
    sha256               arm64_linux:   "cc56f2a984e9b6403b6c4ed6f6a6f0b96d6c1582e6e4c4886e4b8cc9235b78b2"
    sha256               x86_64_linux:  "0b416df707aa5920f94b8a9e8b016b545dbdb157d2ad066103190bdf9821d6a9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
