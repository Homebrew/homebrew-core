class CKermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "http://www.kermitproject.org/"
  url "http://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz"
  version "9.0.302"
  sha256 "0d5f2cd12bdab9401b4c836854ebbf241675051875557783c332a6a40dac0711"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b19ecd36ee298cba626b1276c228cdb4ee57726cf5af64166d8ff2800067e926" => :sierra
    sha256 "446776aff790c8f3b6f30be915dc18f4beffa973b92201384682beb7dc714562" => :el_capitan
    sha256 "fe01b123ec7cddfbf46908bbf2071542a92f195d75733230896b5de78d92cdef" => :yosemite
    sha256 "eebf4b834242dc754c00eb87ee5cee621d39f9369cfe67cdb620a1f81a197f20" => :mavericks
  end

  def install
    system "make", "macosx"
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    assert_match "C-Kermit #{version}",
                 shell_output("#{bin}/kermit -C VERSION,exit")
  end
end
