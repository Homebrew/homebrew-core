class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.21.1.tar.gz"
  sha256 "8b38d177024f2e77b32b35682627f5889f0650c69ab6d602472bdc65a16d8b07"

  bottle do
    cellar :any
    sha256 "0cd60dc28e06ba6e4011d7bea552f306803b36f7e55b3efcdb37646c9bb1fd31" => :mojave
    sha256 "79b60d43229ae1474c5be4f3b1c1774c2063b41050bdf627d410919e47979c93" => :high_sierra
    sha256 "49ed09c1f915a3d61ace7bcac49ec2fb97641f93e58d2a4f89f2023a9af5cd78" => :sierra
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
