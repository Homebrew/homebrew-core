class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.8.tar.gz"
  sha256 "9f8054aaa78acf0ddc020e52b6c7f6737556f2f4c7df16c094ac54e51dd11784"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d025390fee2885debb7b370df065174cd7a62fb14209929b9b55657d152cf6e" => :high_sierra
    sha256 "9f39de92baa73161f3f381d83ca12489a5aaadae0c5e25d24880ffcacd18d695" => :sierra
    sha256 "dbd16b6200c215b91e1e7291364654ce6285675d14f16309a815611290043b87" => :el_capitan
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
