class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  url "https://code.videolan.org/videolan/libplacebo/-/archive/v7.387.0/libplacebo-v7.387.0.tar.bz2"
  sha256 "14ceeeb14d1c08fcdb1a782a06129da11f842c6fddbf3a43c1c4061406ad03d2"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e9ea5b942841c88eb8941ea2a38a5cafddd7a1210a482adf18196db40bd99f3"
    sha256 cellar: :any, arm64_tahoe:       "ef19764cff218aade9c8cfadb88c9899efaac51c701b756cadb83d79164a8ce9"
    sha256 cellar: :any, arm64_sequoia:     "a96048b194f3423ef6fc5c888fa349ea70979fb3135719b8c5290889ff6e44cd"
    sha256 cellar: :any, arm64_linux:       "fc08a0bf041c5aa11c06a8e0802448f0f96292b372a45a41b9426f3ff5dec0bf"
    sha256 cellar: :any, x86_64_linux:      "894e1ba117e487d7edabdd5b1e05a6ce38f07efbd39859c2c3239214b2adc864"
  end

  depends_on "fast_float" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "vulkan-headers" => :build

  depends_on "little-cms2"
  depends_on "shaderc"
  depends_on "vulkan-loader"

  pypi_packages package_name:   "",
                extra_packages: %w[glad2 jinja2]

  resource "glad2" do
    url "https://files.pythonhosted.org/packages/6e/5a/d62b24fe1c7c2f34e15c2aa4418a5327a8550fdc272999a59e0dddebc3ee/glad2-2.0.8.tar.gz"
    sha256 "b84079b9fa404f37171b961bdd1d8da21370e6c818defb8481c5b3fe3d6436da"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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
    inreplace "src/meson.build", "../3rdparty/fast_float/include", formula_opt_include("fast_float")

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
