class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-1.0.2.tar.bz2"
  sha256 "0694c66be5dec41377acead475de69b3d7ffb42c702402f8b713f8b44cdc2791"
  license "GPL-2.0-only"

  livecheck do
    url "https://dl.exactcode.de/oss/exact-image/"
    regex(/href=.*?exact-image[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20317cde1b2c2c9478ee7dd8b35a68f1d3b3360b36362af190a3323cb5429cd8"
    sha256 cellar: :any,                 arm64_monterey: "a11e0789738c798fc3cf6785353e023e4e27b0328aa7ccb5dd63c39b988a0691"
    sha256                               arm64_big_sur:  "47aa8c7861a759d66f553bc8960ba09c14a3b5acf86e2c0f22779379716cac5f"
    sha256 cellar: :any,                 ventura:        "29bb418280be9364ad49399820156acbd0a17b2aa15d0aaa90ce0ecc1c76a6b1"
    sha256 cellar: :any,                 monterey:       "39352ff44276b4d207a58999302b32fa3e6a1918a955c6c3e1d3235ee4654634"
    sha256                               big_sur:        "9b3619df825bd01981c7a7b6fd1b6f88346d7d0fbbb7f9ed8fc30f9fef41cab0"
    sha256                               catalina:       "78a802b0edd2c27640aa2e6be381c146a7fa05bd6dd584ace90b1dfa0e426291"
    sha256                               mojave:         "942bfd38bf5fd52613c936077eee5d5f71530325c7337e9db84e44e0b6c643a0"
    sha256                               high_sierra:    "b182c3fa086d336ee9e6688bb341ea3df8ace70cac451fb757e88ba15c925365"
    sha256                               sierra:         "1a9fc0dbba69ee471deabc6759ca52f3d669a535e021ef2defa33321261010ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8938ff048627f994a89bd563e5372f3d15de40865cd2eb7ac4793599c81ecd49"
  end

  depends_on "pkg-config" => :build
  depends_on "libagg"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bardecode"
  end
end
