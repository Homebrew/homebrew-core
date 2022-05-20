class Libreplaygain < Formula
  desc "Library to implement ReplayGain standard for audio"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/libreplaygain_r475.tar.gz"
  version "r475"
  sha256 "8258bf785547ac2cda43bb195e07522f0a3682f55abe97753c974609ec232482"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.musepack.net/index.php?pg=src"
    regex(/href=.*?libreplaygain[._-](r\d+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "9100ec7606c07112a90c00796c4be0f7ee25e6305f0fbf5baff40fca51eec333"
    sha256 cellar: :any,                 arm64_big_sur:  "e1cafa5a3cc922c818b746cea6e697757dfd1450703678dc0f6ba89eb41c94ac"
    sha256 cellar: :any,                 monterey:       "ea6a3522033b4b63e6f8786f14036cd2e3f685b8ad57050d9a64fc1adcf24e45"
    sha256 cellar: :any,                 big_sur:        "b7a2c4c9ab84445dbe76e5ba32cc84e5f64b4dca4bd0c6ceda202d024a4fcbe6"
    sha256 cellar: :any,                 catalina:       "34a785ef56c26e506e4e225ace636163dd3b5dd310448a7b63d1ba1c99a2ea77"
    sha256 cellar: :any,                 mojave:         "13df0590c2056af8071e5c182bc1b73cfd52b6ad7afb561d16a1ac3ddf0df179"
    sha256 cellar: :any,                 high_sierra:    "c2d3becfcd2f629fb875b6d6c907505489381e5ea3893b0a882510ebbee9951a"
    sha256 cellar: :any,                 sierra:         "d8f7cfc1bfad75b97271300a16f5c927849b03ff488141423ecf48b25c6ed8c3"
    sha256 cellar: :any,                 el_capitan:     "58b52d360c2f37f3ab3a50c4a2fe72b9a370bd951d52939f8853a5ef49fcc322"
    sha256 cellar: :any,                 yosemite:       "d47338c5b86daabf3e2e05ab9dd2443c04c1233f3319307e8e5d545b24dcf722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e25a808e70aa00573bcb1f195bb76b774e8060031e8a188d47eda1fb30fc6a4f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/replaygain/"
  end
end
