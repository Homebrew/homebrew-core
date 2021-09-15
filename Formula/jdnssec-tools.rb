class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://github.com/dblacka/jdnssec-tools"
  url "https://github.com/dblacka/jdnssec-tools/releases/download/v0.15/jdnssec-tools-0.15.tar.gz"
  sha256 "1d4905652639b8b23084366eb2e2b33d5f534bf29fbf9b4becbf9e29f9b39fdf"
  license "LGPL-2.1"
  revision 1
  head "https://github.com/dblacka/jdnssec-tools.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24738bb6c20a997b7cf23b1dd63e559d339fd1765998c5d65974b9f21775b5d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "4341a864f01748c3009213510cc983ef29e354c0e486f14c3fd453ad55ac6802"
    sha256 cellar: :any_skip_relocation, catalina:      "c12eafadb12264e88ef14fe4e93cdb41f0afccbb24b8cff892e8747d8ad2d73b"
    sha256 cellar: :any_skip_relocation, mojave:        "c12eafadb12264e88ef14fe4e93cdb41f0afccbb24b8cff892e8747d8ad2d73b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "c12eafadb12264e88ef14fe4e93cdb41f0afccbb24b8cff892e8747d8ad2d73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069e93f9f47a8553de4bcbe13dbc64082905b2e4e625093a0cb6456a6743ecee"
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
