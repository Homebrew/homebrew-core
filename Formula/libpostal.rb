class Libpostal < Formula
  desc "C library for parsing/normalizing street addresses around the world"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/v1.0.0.tar.gz"
  sha256 "3035af7e15b2894069753975d953fa15a86d968103913dbf8ce4b8aa26231644"
  license "MIT"
  head "https://github.com/openvenues/libpostal.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--datadir=#{share}/libpostal-data",
                          "--prefix=#{prefix}"

    # {ENV.make_jobs} cannot be used as it only works with exactly 4
    system "make", "-j4"
    system "make install"
  end

  test do
    File.exist?("#{include}/libpostal/libpostal.h")
  end
end
