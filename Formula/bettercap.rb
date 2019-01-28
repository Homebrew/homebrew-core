class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.13.tar.gz"
  sha256 "fe7d1dff0f4de079a2cfab92c4593e56c62e666575b52d80401b523a83578a27"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cb29db24499deb00db18579995bcdd5823f1c28a07fb84e38872d113b981522" => :mojave
    sha256 "5285cedd82b0d886d3e1d6f14a39230c025d669e7790f7b639c2d4e53d148761" => :high_sierra
    sha256 "b72092a8d7bdbe0e80a84942fd7c9a16c0246f1501fdbb5db85fb6886d280434" => :sierra
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
