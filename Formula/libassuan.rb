class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.4.tar.bz2"
  sha256 "9e69a102272324de0bb56025779f84fd44901afcc6eac51505f6a63ea5737ca1"

  bottle do
    cellar :any
    sha256 "eb6290ba48859a28998f11b90a1aff14431fa25c02bf8dbdeb0595ea263e5cda" => :high_sierra
    sha256 "807776139dc1196a6107d83cd69d3e81ae9530554933a07cb7c3db7591e795a9" => :sierra
    sha256 "4c657d8c083e8f5835b98eb850a520d2bb9b597afda9229c501fe7cf4e2a1f58" => :el_capitan
    sha256 "9fa0afe044cd12b0cf6509db7c25e90f222e1c41297da41da89524ba0440f1cd" => :yosemite
    sha256 "725c600d3790054cb27290f63256a35d7ab07ea40a05e34c2a8ca4a65b6411ea" => :mavericks
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
