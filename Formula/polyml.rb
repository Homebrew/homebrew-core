class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.tar.gz"
  sha256 "6bcc2c5af91f361ef9e0bb28f39ce20171b0beae73b4db3674df6fc793cec8bf"
  head "https://github.com/polyml/polyml.git"

  bottle do
    rebuild 1
    sha256 "1439f4258d7fa8adfab0b037ae43c5effaffd9b1c7793c05f73a0f130b65d403" => :catalina
    sha256 "356373c5c6483a552164e3aa815076688f37e41d74f8350a52321205f5d4547d" => :mojave
    sha256 "d69da52fe77cd77d079de8ba2b389ced34800cebf55202d023c6800d584a5212" => :high_sierra
  end

  # Patch for Xcode 11
  # https://github.com/polyml/polyml/pull/119
  patch do
    url "https://github.com/polyml/polyml/commit/44efa473.diff?full_index=1"
    sha256 "0835165da3f0b540c13e06d79dfdc4bcbcc4cde17207ea2e02978582552ee4d0"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
