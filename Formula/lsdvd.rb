class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/lsdvd-0.17.tar.gz"
  sha256 "7d2c5bd964acd266b99a61d9054ea64e01204e8e3e1a107abe41b1274969e488"

  bottle do
    cellar :any
    sha256 "d64473d3ff0f1b1b7dce0435da6305aa384a374ebca7154498770a9c66297cb7" => :sierra
    sha256 "eefa4b673d38a87354cdac631ee7e7a1054e69e29e912ff52c2fa84995f7e189" => :el_capitan
    sha256 "4662e19252627e7f8e344fc0f8b52e83e908f26e9253aad7590eef126ebae7f0" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"
  depends_on "libdvdcss" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"lsdvd", "--help"
  end
end
