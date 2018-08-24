class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.4.tar.bz2"
  sha256 "df27ec3ff24671f80b29e6ab1c4971059c14ac3db95406884fc26574631ba8d5"
  revision 1

  bottle do
    cellar :any
    sha256 "8b928fd9ce46279d60a9ac73f795f3e068cc1478fcae4aabc8f7231d972820ec" => :mojave
    sha256 "0c9517138125951ae8fd38f026aa970bb877f1ae7564e47863cdf64a2adebb2e" => :high_sierra
    sha256 "a298e371464c6bcbe67c5f0c8b23de398980ad3a5ac3e8507f0ee29fef0c9e13" => :sierra
    sha256 "91161dd227491e058a9ca79ca89bb647d2bac5e368bed5457fc80a30d383ff2d" => :el_capitan
  end

  # CVE-2016-3977
  # https://sourceforge.net/p/giflib/bugs/102/
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=820526
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/giflib/giflib_5.1.4-3.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/giflib/giflib_5.1.4-3.debian.tar.xz"
    sha256 "767ea03c1948fa203626107ead3d8b08687a3478d6fbe4690986d545fb1d60bf"
    apply "patches/CVE-2016-3977.patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
