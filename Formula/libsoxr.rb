class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.2-Source.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libs/libsoxr/libsoxr_0.1.2.orig.tar.xz"
  sha256 "54e6f434f1c491388cd92f0e3c47f1ade082cc24327bdc43762f7d1eefe0c275"

  bottle do
    cellar :any
    sha256 "077ef8de96bc1d6e91c102a1ef37a8abdfc5a5c58e630ddf4c71d588f4928514" => :el_capitan
    sha256 "b4a93f140c6811066af0a9c4ed5018426cacd57708aeed413b81ff887823926e" => :yosemite
    sha256 "ab97e9c831858081a06933a5394623b8e4dbafd660e507cfbe851dee07c73c09" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
