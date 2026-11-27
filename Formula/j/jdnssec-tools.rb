class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://github.com/dblacka/jdnssec-tools"
  url "https://github.com/dblacka/jdnssec-tools/releases/download/v0.22.1/jdnssec-tools-0.22.1.tar.gz"
  sha256 "ea1ee96c0b2e4d7819ca1e3defb070c97015d8bf7d558024010c68125cd9ae55"
  license "LGPL-2.1-or-later"
  head "https://github.com/dblacka/jdnssec-tools.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d84cf93ece7f021946718736a74935715a6f2034bb1e4c20c45c523514b5bd3f"
    sha256 cellar: :any_skip_relocation, all: "335b0bdd8d56fab77cfad389f7b53ee11b21c9af83df56cef1c80463b48b1401"
  end

  depends_on "openjdk"

  def install
    inreplace Dir["bin/*"], /basedir=.*/, "basedir=#{libexec}"
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk")
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
