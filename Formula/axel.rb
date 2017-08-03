class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/eribertomota/axel/archive/2.13.1.tar.gz"
  sha256 "e19253223fc0a6d6142190661f9fcbd5809dc5acc5b7013c98c979673a2f7195"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "f6eade207e6f38d546026493cb711e694554771544db7342ade340b04f0f72c3" => :sierra
    sha256 "6e99da46b83e38b8145a6556e7c70a1e8b31df1f600c87d1c55190a77e0d2626" => :el_capitan
    sha256 "e8b8cbea1f9fc02dccefe9f1985bb04f6a502bf152b890659603eac3b3a3763e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
