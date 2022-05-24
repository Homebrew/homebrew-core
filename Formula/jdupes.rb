class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.20.2.tar.gz"
  sha256 "d079d22dc77e1d181abcb8a59216520633a8712d197d007a9a9fb64c72610824"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3937038afc1820f1f774fbd22f35c8fe466e70f0588fe75cc3828f15dcf6653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c844afb4e9fba5b763ae1378a8629e9956f251c8ad9c1e0c74d8d0d18668274"
    sha256 cellar: :any_skip_relocation, monterey:       "263316d819220f93765f67a80757c9b5769f3132bab17874bfd1d9de40aa60cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e39c1b51399b4c6cd2b39624bd8c7957643fd9abbd537cb75f3663619e355b8"
    sha256 cellar: :any_skip_relocation, catalina:       "9fadc414239619b0ed49beb9e31ade91fc917fe8d2ec37ea3be9ced6701a491d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b03a8221e4d828bed9072894e8a78151478a70283ec9ca98f95dbdc83eeeeb8"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
