class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://github.com/dblacka/jdnssec-tools"
  url "https://github.com/dblacka/jdnssec-tools/releases/download/0.14/jdnssec-tools-0.14.tar.gz"
  sha256 "96dfe5465452713c07461a8744f166e6f0e199e2236c3a5fe02f17b49438885c"
  head "https://github.com/dblacka/jdnssec-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc1a026b38600f8f1d6eb28ece1ccc714f92b35decb2648310f0e8c67c66386d" => :mojave
    sha256 "410115bfea6c2107754902e990fcc5a365a9330fe72035627843ccc12426d559" => :high_sierra
    sha256 "4a39d75830447d4399772906dac12fb9444c8ddaef618874dbb8db06bf7aa288" => :sierra
    sha256 "0b48a68553a1d76d38efe6557d7bc52662a3b361f5f07a44c128d5e15be4622c" => :el_capitan
    sha256 "0b48a68553a1d76d38efe6557d7bc52662a3b361f5f07a44c128d5e15be4622c" => :yosemite
  end

  depends_on :java

  def install
    inreplace Dir["bin/*"], /basedir=.*/, "basedir=#{libexec}"
    bin.install Dir["bin/*"]
    (libexec/"lib").install Dir["lib/*"]
  end

  test do
    (testpath/"powerdns.com.key").write(
      "powerdns.com.   10773 IN  DNSKEY  257 3 8 (AwEAAb/+pXOZWYQ8mv9WM5dFva8
      WU9jcIUdDuEjldbyfnkQ/xlrJC5zA EfhYhrea3SmIPmMTDimLqbh3/4SMTNPTUF+9+U1vp
      NfIRTFadqsmuU9F ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04
      Cx83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE 1LpnJI/wcUpRU
      iuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW UbULpRa/il+Cr5Taj988HqX9Xdm
      6FjcP4Lbuds/44U7U8du224Q8jTrZ 57Yvj4VDQKc=)",
    )

    assert_match /D4C3D5552B8679FAEEBC317E5F048B614B2E5F607DC57F1553182D49AB2179F7/,
      shell_output("#{bin}/jdnssec-dstool -d 2 powerdns.com.key")
  end
end
