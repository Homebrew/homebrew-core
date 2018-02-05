class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.9/cryfs-0.9.9.tar.xz"
  sha256 "aa8d90bb4c821cf8347f0f4cbc5f68a1e0f4eb461ffd8f1ee093c4d37eac2908"
  head "https://github.com/cryfs/cryfs.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "1e0726d2924e3ec3a4be4edec6f5a4252eb65494ec4ac579de38828c4308c70f" => :high_sierra
    sha256 "e1854431529f362df8ba40ef344b118cf5b3bae72f7d3fbf0d21209f439d1838" => :sierra
    sha256 "f70065ad596bbb700ad778ea0cdc19a295185fdf9653539ff75cbcfebd71e3bd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cryptopp"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    system "cmake", ".", "-DBUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"
    assert_match "CryFS", shell_output("#{bin}/cryfs", 10)
  end
end
