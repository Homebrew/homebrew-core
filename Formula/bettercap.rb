class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.16.tar.gz"
  sha256 "75291742df7ced2fc7daa445c87c90aecdd21249892bc6664a5acf2a50c2fa22"

  bottle do
    cellar :any_skip_relocation
    sha256 "c20b35c8e12517bb6d34054d2b46b75debda0e1c419169d5b294496b7f46a8bd" => :mojave
    sha256 "2c7d6a60a3151aedcc31f9d505849f3171c2ce073bdc55be5afbe76df9cf6548" => :high_sierra
    sha256 "85fd76855878e17e5182b111ba58f4f7d4c7483f75841664cc168c7466c4958d" => :sierra
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
