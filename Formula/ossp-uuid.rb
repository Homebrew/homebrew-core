class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "https://web.archive.org/web/www.ossp.org/pkg/lib/uuid/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0"
  revision 2

  bottle do
    cellar :any
    sha256 "a6852dac557e1b804a240b4f558d9b2e262adebb64424061f2ee8002a3d19476" => :mojave
    sha256 "a04214b22c58bd5167778925cb9e55b98f28330bcc6c6a37929e6085ea3a0162" => :high_sierra
    sha256 "3c15cd0e25e3039e0d05b94d14b714745cec3033863d5dc7a6d9ddd7cacc1c71" => :sierra
    sha256 "ac4456fc1c29db7e0d565ebdd392cf827be315b52c9eb3abcd113c4c7b981f25" => :el_capitan
    sha256 "c6cfa39816d19fa8d4586d6a364cd17e3a089ea018242875dc371731578a4ac7" => :yosemite
    sha256 "5253f4fab035aca3ca3b867ce0d081812eb17fe0dcaab6599087abaa385c478d" => :mavericks
  end

  def install
    # upstream ticket: http://cvs.ossp.org/tktview?tn=200
    # pkg-config --cflags uuid returns the wrong directory since we override the
    # default, but uuid.pc.in does not use it
    inreplace "uuid.pc.in" do |s|
      s.gsub! /^(exec_prefix)=\$\{prefix\}$/, '\1=@\1@'
      s.gsub! %r{^(includedir)=\$\{prefix\}/include$}, '\1=@\1@'
      s.gsub! %r{^(libdir)=\$\{exec_prefix\}/lib$}, '\1=@\1@'
    end

    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{include}/ossp",
                          "--without-perl",
                          "--without-php",
                          "--without-pgsql"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uuid-config", "--version"
  end
end
