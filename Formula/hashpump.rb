class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  revision 2

  bottle do
    cellar :any
    sha256 "7d66b2aeb0e9cd16362173d78d4291e5b4095a00f56b6a41fb67ba4fb6ee9e78" => :mojave
    sha256 "880a577b7b664a653797e8be8d3dacde7050786c9bdda08758f43e62b5f4cc82" => :high_sierra
    sha256 "ca23c693b5c3d7786cbbe385b540e5e0aec7267c7e378d4b7e3ca88d6b3847b4" => :sierra
  end

  depends_on "openssl"
  depends_on "python"

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/pull/14.patch?full_index=1"
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
