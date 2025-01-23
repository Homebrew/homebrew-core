class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://github.com/dblacka/jdnssec-tools"
  url "https://github.com/dblacka/jdnssec-tools/releases/download/v0.20/jdnssec-tools-0.20.tar.gz"
  sha256 "cddc024726e11e014ff02c04135743f3cb3964ed8fe2487d17544e60230f10d6"
  license "LGPL-2.1-or-later"
  head "https://github.com/dblacka/jdnssec-tools.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15408395c8e88ae2baa48cfbe3f2cd2850b6805f8b42fe1613734f6fdc131d3b"
  end

  depends_on "openjdk"

  def install
    inreplace Dir["bin/*"], /basedir=.*/, "basedir=#{libexec}"
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
    (libexec/"lib").install Dir["lib/*"]
  end

  test do
    (testpath/"powerdns.com.key").write <<~EOS
      powerdns.com.   10773 IN  DNSKEY  257 3 8 (AwEAAb/+pXOZWYQ8mv9WM5dFva8
      WU9jcIUdDuEjldbyfnkQ/xlrJC5zA EfhYhrea3SmIPmMTDimLqbh3/4SMTNPTUF+9+U1vp
      NfIRTFadqsmuU9F ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04
      Cx83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE 1LpnJI/wcUpRU
      iuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW UbULpRa/il+Cr5Taj988HqX9Xdm
      6FjcP4Lbuds/44U7U8du224Q8jTrZ 57Yvj4VDQKc=)
    EOS

    assert_match "D4C3D5552B8679FAEEBC317E5F048B614B2E5F607DC57F1553182D49AB2179F7",
      shell_output("#{bin}/jdnssec-dstool -d 2 powerdns.com.key")
  end
end
