class Packetq < Formula
  desc "SQL-frontend to PCAP-files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.4.3.tar.gz"
  sha256 "330fcdf63e56a97c5321726f48f28a76a7d574318dd235a16dac27f43277b0b7"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "78b947bf8208aceefdbca0119ed141b5617347ce08f20ce6493157ab4a567c77" => :big_sur
    sha256 "daad15e1b55f8d9fb135177127a169470374dd5e4c8631b1722586d1c66af8a7" => :arm64_big_sur
    sha256 "e09c6588aa801951e518c10e09339d496fa23ab88c0a837a06b963bf6c6a5ba9" => :catalina
    sha256 "cf369b7e772dd7a390ca50f68e6b8eead2448414353ce313042ecaedb2f6ee88" => :mojave
    sha256 "58bfb682012318c49bb013b791771f94896d008d77f0ce1bb189d13ab55b20ea" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
