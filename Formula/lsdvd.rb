class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/lsdvd-0.17.tar.gz"
  sha256 "7d2c5bd964acd266b99a61d9054ea64e01204e8e3e1a107abe41b1274969e488"

  bottle do
    cellar :any
    sha256 "24d7f2b86648de4b7477d41b0a2adfefa870ac2a973f4a31e16bb88a88fc3904" => :sierra
    sha256 "29aa32a4b1b1c327aaea8b568f625c0c8e49723a3397d722df927e0b1b4493d7" => :el_capitan
    sha256 "9af38820e4747c002f38be75d31577533980ca731f12cffc2b9f41c6a37e1a3d" => :yosemite
    sha256 "b00f07a2636d1d73ab1b3456843d35de78e01f98f9ac818c4f0d70a88893253b" => :mavericks
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
