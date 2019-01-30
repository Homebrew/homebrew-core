class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.13.1.tar.gz"
  sha256 "22e75ba7d76aca157479bd7958650d4f0aa87fafbbc333f030783898592b73e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "5103a1066e134ec29da0fd4c7f0ac064a1c98e2933d1307c71d1af1ca6d27efe" => :mojave
    sha256 "aa2ace10b85a93fa5896e1702c74594d2c23199d34164a4b26d2ab2ecc1d5de3" => :high_sierra
    sha256 "3389211cb27f53f50101ea086eb15686919e6d20d9bc23c9fd1a9e793e19ef17" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
