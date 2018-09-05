class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.8.tar.gz"
  sha256 "9f8054aaa78acf0ddc020e52b6c7f6737556f2f4c7df16c094ac54e51dd11784"

  bottle do
    cellar :any_skip_relocation
    sha256 "6afa77446b3dd20528a9d0a9093edf94fd99d11df735c0189e9f36e8fd9b87bd" => :mojave
    sha256 "777c535f59cd35fccd423f0e02e9a19dcf34e3ae2c6be0a6ed77fe85b7d2bf5b" => :high_sierra
    sha256 "d15cb1c75fc963278559ad93906e4201baa8edbccb4893969f047875474ecf67" => :sierra
    sha256 "52c420cea24a677535402a6aa80cf190ae33fdef3a0bc332d4dd701775bd1059" => :el_capitan
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
