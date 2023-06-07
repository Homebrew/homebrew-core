class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://github.com/Talinx/jp2a"
  url "https://github.com/Talinx/jp2a/releases/download/v1.1.1/jp2a-1.1.1.tar.bz2"
  sha256 "3b91f26f79eca4e963b1b1ae2473722a706bf642218f20bfe4ade5333aebb106"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e250080a0acfad041dd4ab5246745289b412b70bde5e5faf5a5a7772c77ac5c"
    sha256 cellar: :any,                 arm64_monterey: "6671f5e26d2f10f2babad8e13f87e554b774e033c7c990bff7f832084af26e80"
    sha256 cellar: :any,                 arm64_big_sur:  "4f40ed84caf4c25b97d185bcfbf0ac9a02be69b92476568627c429faa4360e63"
    sha256 cellar: :any,                 ventura:        "cda95f11e31d42ef0489ad9b7e3a42fcd1689214b97809ba8d4117c3797e38bf"
    sha256 cellar: :any,                 monterey:       "c3cdaa3c306dd0b8ca5ea9af175748274f651778f01126ad2e31efc8c8edcff7"
    sha256 cellar: :any,                 big_sur:        "145e3daceb2d06c33703e0897d40838cde1236a09ca84ca25b7c2fad5682dfed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0de0b9e6c0216bd53dd2bb7a978f29caa841cc3bdddaad9ddd8a3d7b1797b8"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
