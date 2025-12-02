class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://github.com/fukuchi/libqrencode/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "5385bc1b8c2f20f3b91d258bf8ccc8cf62023935df2d2676b5b67049f31a049c"
  license "LGPL-2.1-or-later"
  head "https://github.com/fukuchi/libqrencode.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "43022662b77fc3e4181eb5b0d8e671f6208c9217c307073c2e76d4e5c98ea9f9"
    sha256 cellar: :any,                 arm64_sequoia: "3fec9ad635eb185c133cca4e3ab3e8ab7c2094453c462c457b1e5624960bca35"
    sha256 cellar: :any,                 arm64_sonoma:  "74e41b86ddec16b100ac17a756235f377b0e7b8990af8e37a66571b204db40c8"
    sha256 cellar: :any,                 arm64_ventura: "01e05ae6c40b460ebc0dbba2fe76a4310ee538a692e7712dda77c07e18789ed8"
    sha256 cellar: :any,                 sonoma:        "b9af340917ff148b24e48c24e5313423e16df56a99a7a612d0b23af59e2394b9"
    sha256 cellar: :any,                 ventura:       "6995e471fbd7e8f9c3c507e7576ba53a5636fb329a049f61f54494b7b5d9fe2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a598b96cd3fa15c9c028d7c6d86f884ece57ac86feca9939e862b17a14143bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181bcd364cef78e8be564a42859f3b431febc429fc3db940d5c06bb572493999"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"

  def install
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qrencode", "123456789", "-o", "test.png"
  end
end
