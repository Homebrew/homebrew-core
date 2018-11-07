class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.10.tar.gz"
  sha256 "47b85e806f7ccf07a0b4a0d28226d7e568fbde2b68b1def7be17d113be8ec34e"

  bottle do
    cellar :any_skip_relocation
    sha256 "077757ac2cbffac741c9cb4ff3f2fad92281b5696d3bc74b13e81f51ae9345af" => :mojave
    sha256 "bf15aeb30ff06f1a49bf2793e6c77052b2d2136fc479abf3398320b19c94c930" => :high_sierra
    sha256 "ab1735934423e305c02d0ff99a12a5ff8e3886c8407c5f345c5a4e595ef27027" => :sierra
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
