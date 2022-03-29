class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-5.1.tar.gz"
  sha256 "1ee5268c063d76646af2b4426052e7d81a42b657e6a77d8e7d3d2e60fd7409fe"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?fping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "087d83a0737273f2a17e731d6dd3a850a73b09bb8bb1ffa79d557af23acbddbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5fa545f848ec9144a99596c909227193d63858b01cdb0feacf564a2a021846d"
    sha256 cellar: :any_skip_relocation, monterey:       "11128619d0c6500c6aadc9b81f4953fc78ea965fe158d296072519089708a674"
    sha256 cellar: :any_skip_relocation, big_sur:        "04bb01d86dd906a4fc5b63ed165a4bc936ab436fd17b567f8f6ddcd051ab4ab5"
    sha256 cellar: :any_skip_relocation, catalina:       "fc706bf9bcb8a3fa881fe02b1987618745bfb50be7cfa4ace24b02ad40d7f8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10618282a7eb3078c424117e81046f0d58f87fa98bbae3ad415d8aa8d47b26c8"
  end

  head do
    url "https://github.com/schweikert/fping.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fping --version")
    assert_match "Probing options:", shell_output("#{bin}/fping --help")
    if OS.mac?
      assert_equal "::1 is alive", shell_output("#{bin}/fping -A localhost").chomp
    else
      assert_match "can't create socket", shell_output("#{bin}/fping -A localhost 2>&1", 4)
    end
  end
end
