class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.4.3/laszip-src-3.4.3.tar.gz"
  sha256 "53f546a7f06fc969b38d1d71cceb1862b4fc2c4a0965191a0eee81a57c7b373d"
  license "LGPL-2.1-or-later"
  head "https://github.com/LASzip/LASzip.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d2325d42a6958fad99c62e6330f6081fcf0bb95568345a321eb301cff46549d"
    sha256 cellar: :any,                 arm64_monterey: "5064bc999925063dab10850a16565f0e6146565496fe53357b138dffbe5ade18"
    sha256                               arm64_big_sur:  "6849693f9166120961fcada7af8d222c1e7580bc191d75a3fdef7ca685f22566"
    sha256 cellar: :any,                 ventura:        "f2928df3b4e05788c49e8f6b8b4180e5c5c74c8e29939adede4186ddde872a64"
    sha256 cellar: :any,                 monterey:       "eca7c603a0e7a894cc63acdfbf2a77536f82b35ad26106f32e2ed03ec6fa5b90"
    sha256                               big_sur:        "3b8bf75cb5a0c7f2ac6b02c59726b9b2d126ac754dc24a45ffff3adb18bc1a15"
    sha256                               catalina:       "df73f3c2c8be13bc0fab13f28cbb22262a24c283f4da85cf6b21c55531516e7f"
    sha256                               mojave:         "3a9bc6d5931145800cb5792740a3cae118d27c4879144f3c74a44c2aee75ce64"
    sha256                               high_sierra:    "a32459a4896bdc365fae55b70744bb7ae2a05b552e3bb0b0097345e0ea423014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead7c79d5802c0c0c60e8d07cd70d62d634efe3447ff0bc69b576e29f05c82e9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/laszipdllexample.cpp", "-L#{lib}",
                    "-llaszip", "-llaszip_api", "-Wno-format", "-ldl", "-o", "test"
    assert_match "LASzip DLL", shell_output("./test -h 2>&1", 1)
  end
end
