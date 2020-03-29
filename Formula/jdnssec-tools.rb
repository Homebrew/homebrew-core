class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://github.com/dblacka/jdnssec-tools"
  url "https://github.com/dblacka/jdnssec-tools/releases/download/v0.15/jdnssec-tools-0.15.tar.gz"
  sha256 "1d4905652639b8b23084366eb2e2b33d5f534bf29fbf9b4becbf9e29f9b39fdf"
  revision 1
  head "https://github.com/dblacka/jdnssec-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c12eafadb12264e88ef14fe4e93cdb41f0afccbb24b8cff892e8747d8ad2d73b" => :catalina
    sha256 "c12eafadb12264e88ef14fe4e93cdb41f0afccbb24b8cff892e8747d8ad2d73b" => :mojave
    sha256 "c12eafadb12264e88ef14fe4e93cdb41f0afccbb24b8cff892e8747d8ad2d73b" => :high_sierra
  end

  depends_on "openjdk"

  def install
    inreplace Dir["bin/*"], /basedir=.*/, "basedir=#{libexec}"
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
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
