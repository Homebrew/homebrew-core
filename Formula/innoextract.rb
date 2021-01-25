class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "3b94866e12023ad789180061c250d340be0ca879730453e268d712026558fffb" => :big_sur
    sha256 "0b3f7137df6e506c374ac8ffbed6cba4724beb4a14e59b0db0b8259d3ea6ccc7" => :arm64_big_sur
    sha256 "d929af92d772abc9d2e243044250bf536d1703c2d2b124ad26a65989ecba8bce" => :catalina
    sha256 "c65b57194a8adccdb33db63b0061fbcf94d1e8a1b4b62a441d94ae99c7512adb" => :mojave
    sha256 "83b502512cbdce3329d67f2e4a9784e77632c0f8b672854fef5561e542214e3c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
