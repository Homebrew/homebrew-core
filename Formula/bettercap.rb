class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.18.tar.gz"
  sha256 "fa7192ce330a4c6f7e37974a26826f61be4407d1ee8994f5d732cfed4dab5b74"

  bottle do
    cellar :any
    sha256 "d6d1af4fe8c00d22aaefe5444b7aa96ec089abfe9a0aa3b294784bc24afb6f70" => :mojave
    sha256 "237fac184ed8ca40437ad5dee9c7184e3038d87d3bdcfe1ea0c623f2a9c90912" => :high_sierra
    sha256 "144839353b66662cab7ca93a6e216f7d0cf3a946785e7e1e3ab3497986281763" => :sierra
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
