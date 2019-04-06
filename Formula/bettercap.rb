class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.22.tar.gz"
  sha256 "5bcbde5785dd2983f6379f8bbc5f286fe8e53295cf1e04a8042fa467f345e7f4"

  bottle do
    cellar :any
    sha256 "b4d4ab97b06f2b9f21ac42f81b365d64ea05467d89c91373841735f38388068a" => :mojave
    sha256 "bd847ba574e13e6b76df2f083d97eec3c01df79f141b58f6a7d761f0e555a929" => :high_sierra
    sha256 "e6950b2c923628d4cbab5ac03e1f0fd50d25378742ce0fe4e361acb5a95468fa" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

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
