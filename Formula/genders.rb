class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://github.com/chaos/genders"
  url "https://github.com/chaos/genders/archive/genders-1-27-3.tar.gz"
  version "1.27.3"
  sha256 "c176045a7dd125313d44abcb7968ded61826028fe906028a2967442426229894"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/genders[._-]v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "8979f90c79fcf64e0edb58eb16afeadae1a525a7ae7116ed5ad191d3be93c83f"
    sha256 cellar: :any, arm64_big_sur:  "36d036a70a6833bdfd9dd86289c5c97c90ac54e10fdf7fdddb9438410ae556e4"
    sha256 cellar: :any, monterey:       "c93e0650faa66822115dac4284f9af726b9704ceb01bc92cfb5ce9df852fed81"
    sha256 cellar: :any, big_sur:        "9134738efeeeee06bdf84158390bdb848bf92c3b6099f7e9ca66756a3e268b9e"
    sha256 cellar: :any, catalina:       "e1bbeeb4bc32d8655ea35718825175dc1293a1cebd059437cf2fcc9001d159e2"
    sha256 cellar: :any, mojave:         "353ba0eda08b2c75c72e72c2782fb72becb095b2a2875406651c48837dde4223"
    sha256 cellar: :any, high_sierra:    "31a726904f22c156b763a8bc95bd3db6e85b8bc0cf7d8a82d584bb8684241f6c"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-java-extensions=no"
    system "make", "install"
  end

  test do
    (testpath/"cluster").write <<~EOS
      # slc cluster genders file
      slci,slcj,slc[0-15]  eth2=e%n,cluster=slc,all
      slci                 passwdhost
      slci,slcj            management
      slc[1-15]            compute
    EOS
    assert_match "0 parse errors discovered", shell_output("#{bin}/nodeattr -f cluster -k 2>&1")
  end
end
