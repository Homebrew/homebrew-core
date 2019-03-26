class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.20.tar.gz"
  sha256 "f9c6d2f77b59e809f425f3489c194bd21120b8d30819afc18bab617ac6d47cac"

  bottle do
    cellar :any
    sha256 "90257901fbfee927260143eda7143008b8ea50525aada58a8e13beb50e3db05f" => :mojave
    sha256 "079e692cd9f19f9a378dcc4996d30a1793362fdfb1b11ad393573760f063d7fe" => :high_sierra
    sha256 "0e6dda6ff0d456b3aded49c04783bd6871932b620433ec0456eaf5c08bf2f28d" => :sierra
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
