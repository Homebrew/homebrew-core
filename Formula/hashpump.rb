class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  revision 3

  bottle do
    cellar :any
    sha256 "5137114b347ef2c2cd42ce982c0b8d6fa261d6b7105b4735a6e8e8c5c6154448" => :catalina
    sha256 "ddd00b7f11649d0ad36bdc9bfa724daee15e135687a1d71c5f043aa758b15399" => :mojave
    sha256 "dd22c32a8a2c4ade6b45e573b61d09d91f56c60a74c7fd9265fb75e8dc60be5f" => :high_sierra
    sha256 "91dd089a608636170ad9ba63f5095f254773d510e0eaf48735aa35c3cf6d9bf2" => :sierra
  end

  depends_on "openssl@1.1"
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
