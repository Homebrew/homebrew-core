class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://github.com/dblacka/jdnssec-tools"
  url "https://github.com/dblacka/jdnssec-tools/releases/download/v0.17.1/jdnssec-tools-0.17.1.tar.gz"
  sha256 "d710e8f1d33a20337f6f9bf6e06787d315f4c821d68aa7b347032c2c7331628f"
  license "LGPL-2.1"
  head "https://github.com/dblacka/jdnssec-tools.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, ventura:        "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, monterey:       "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cdfb19fee503d97618bc2987e71eb669405fe7bee91f5e911721300319a6b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9924bbccc4783e0490e07259de930f8618cc6da78dcf08fcef664844a8a6c60d"
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
