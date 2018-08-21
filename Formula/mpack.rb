class Mpack < Formula
  desc "MIME mail packing and unpacking"
  homepage "http://ftp.andrew.cmu.edu/pub/mpack/"
  url "http://ftp.andrew.cmu.edu/pub/mpack/mpack-1.6.tar.gz"
  sha256 "274108bb3a39982a4efc14fb3a65298e66c8e71367c3dabf49338162d207a94c"

  bottle do
    cellar :any_skip_relocation
    sha256 "edbef02feb0f06f807c864f872cf7f5ac42bbf65a40249e92a3e990f5c1bfa4e" => :mojave
    sha256 "3010b6b97b6388a250e18278f1ec45b27244898876856d53e776b75ecd0c6bf3" => :high_sierra
    sha256 "4dac8e937f170ddcae76e90143e7b1a6b0bd66e730d683ab83693d55dd670f2b" => :sierra
    sha256 "f0f9bd526ff3c7e8a1abea377e3716fee96916c0c54234d96b46a475b50b8c1e" => :el_capitan
    sha256 "f5455f95c52ffc59181037ea3fd8151006178dfd6abb9674be65b2996f876766" => :yosemite
    sha256 "9090f5b1263e27adfdd359ee1a052a71edb681d4305cfd921488b1533f8bfcf8" => :mavericks
  end

  # Fix missing return value; clang refuses to compile otherwise
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1ad38a9c/mpack/uudecode.c.patch"
    sha256 "52ad1592ee4b137cde6ddb3c26e3541fa0dcea55c53ae8b37546cd566c897a43"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
