class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/faac-1.31.1.tar.gz"
  sha256 "3191bf1b131f1213221ed86f65c2dfabf22d41f6b3771e7e65b6d29478433527"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00c66e8dd158e8c2f606e0707c261f8b5438951e9b38e316949900152058ddca"
    sha256 cellar: :any,                 arm64_sequoia: "8daa11b4e9cf3a79ee7cd68c63e5f5902a127fe7546d2ce93d7ca2fb345ef2ab"
    sha256 cellar: :any,                 arm64_sonoma:  "2cdb819aadff92bd69b07f182b9fa709d30694fec7df650f211a341e1fc3128c"
    sha256 cellar: :any,                 arm64_ventura: "1a0d7a2fc58b61e1d5b01e72377c884975322848de30125eae644c0fb75517f7"
    sha256 cellar: :any,                 sonoma:        "89a3968e3fcff90660fc6de8c59173f4b0b36769141875971edf0100956a428d"
    sha256 cellar: :any,                 ventura:       "b4f7efe2d732e7df635323384fd884a319d3bd9852d8f1afc7e2e7b65ced184d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99c3b48cc15f3987c5d70cae13c4a8b4b3fd9d47543fc7fa77552c2be2c1cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30940df984b4f44d7c7b4bb0f55de660262490bf0e0288edfe5f5e673c26cea9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_path_exists testpath/"test.m4a"
  end
end
