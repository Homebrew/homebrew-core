class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2d6ec2e245a2ba6eab0039a3ed0b958c280a38f1a6914e8da041b45d299c4e7d"
    sha256 cellar: :any,                 arm64_big_sur:  "0b3f7137df6e506c374ac8ffbed6cba4724beb4a14e59b0db0b8259d3ea6ccc7"
    sha256 cellar: :any,                 monterey:       "25ab96b5358d9f46a331ebe99ed0d785bfb95f622b76ea03636fee73380a255b"
    sha256 cellar: :any,                 big_sur:        "3b94866e12023ad789180061c250d340be0ca879730453e268d712026558fffb"
    sha256 cellar: :any,                 catalina:       "d929af92d772abc9d2e243044250bf536d1703c2d2b124ad26a65989ecba8bce"
    sha256 cellar: :any,                 mojave:         "c65b57194a8adccdb33db63b0061fbcf94d1e8a1b4b62a441d94ae99c7512adb"
    sha256 cellar: :any,                 high_sierra:    "83b502512cbdce3329d67f2e4a9784e77632c0f8b672854fef5561e542214e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370b32c57c52a70104321f2c4c0f48200868ba5815dcc37753a412c5e65d7a4c"
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
