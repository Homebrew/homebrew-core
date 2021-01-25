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
    cellar :any
    sha256 "9134738efeeeee06bdf84158390bdb848bf92c3b6099f7e9ca66756a3e268b9e" => :big_sur
    sha256 "36d036a70a6833bdfd9dd86289c5c97c90ac54e10fdf7fdddb9438410ae556e4" => :arm64_big_sur
    sha256 "e1bbeeb4bc32d8655ea35718825175dc1293a1cebd059437cf2fcc9001d159e2" => :catalina
    sha256 "353ba0eda08b2c75c72e72c2782fb72becb095b2a2875406651c48837dde4223" => :mojave
    sha256 "31a726904f22c156b763a8bc95bd3db6e85b8bc0cf7d8a82d584bb8684241f6c" => :high_sierra
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
