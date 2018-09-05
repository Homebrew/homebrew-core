class Libcmph < Formula
  desc "C minimal perfect hashing library"
  homepage "https://cmph.sourceforge.io"
  url "https://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz"
  sha256 "ad6c9a75ff3da1fb1222cac0c1d9877f4f2366c5c61c92338c942314230cba76"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e8163bd5b5de8d4faa7c797432abd2d5d5f411e78d0d23cb851d7bca82b3c24f" => :mojave
    sha256 "31113e8e40d7f6b1c95976b83e74bb46b1fb2f927eb32adf5aac3a3aafb15811" => :high_sierra
    sha256 "925bfc37517acf2e0284e3d70280848104107b5aa1c6dd3402b3d4b1f03ab59a" => :sierra
    sha256 "583c5008fe59058f8bd9166660462acfb583feee646472d546587e3e326059cb" => :el_capitan
    sha256 "4dba37edbd9ec4f32fcb911cbec5cbd457001c3f6a26f14a3ff88a412a42f017" => :yosemite
    sha256 "ba56f5d7f7c750329312dbf4d43d5d937320082ab32fe35ec84b05aecff125ee" => :mavericks
    sha256 "af52629547db4cef5a17fb5c4b46b8da9f165e9a9aed4bdd7f87d43d37e65687" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
