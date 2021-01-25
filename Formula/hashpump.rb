class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  license "MIT"
  revision 5

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "ad196de95f0c2a2c8edb6d2be9ee24652c44aeeb981c4103964a583fad3bf6da" => :big_sur
    sha256 "f927c386e75aa33a6116249b4853db671cee00beadd86c5f76c78641c59254ba" => :arm64_big_sur
    sha256 "96dc135554b1dfa6b432120e716ab925ed28f9ea570ee2741816bb3309fbc9bb" => :catalina
    sha256 "0f9dc011b37341b4b0c6817738811d4825910aab7f25c6a34fe62e85e679281a" => :mojave
    sha256 "9ca69bd8f3c736e915db2f5b80de0b804170f6f2a71876fa4656c788187db6e7" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "python@3.9"

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/commit/1d76a269d18319ea3cc9123901ea8cf240f7cc34.patch?full_index=1"
    sha256 "ffc978cbc07521796c0738df77a3e40d79de0875156f9440ef63eca06b2e2779"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"

    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = `#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' \\
      -d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' \\
      -a '&waffle=liege' -k 14`
    assert_match /0e41270260895979317fff3898ab85668953aaa2/, output
    assert_match /&waffle=liege/, output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
