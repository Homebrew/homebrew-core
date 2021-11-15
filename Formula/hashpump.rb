class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  license "MIT"
  revision 6

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "80e49f28b84facab3feb5206f81c06ad143afee7e6eb01a162a58868322ee034"
    sha256 cellar: :any,                 arm64_big_sur:  "6e99a5af9995bdd57bae97fc6b0e8791bc4b2992127da7a394b1429fbb84c897"
    sha256 cellar: :any,                 monterey:       "4e557d1bf36c17fbb92c3ce64c5f97bf590e5cb39e6a2ac5d15325c7f1f8669a"
    sha256 cellar: :any,                 big_sur:        "9938b4bc8733e829df629daa8b267211ab98b3dd6d2b7c16fee4eabbefa22372"
    sha256 cellar: :any,                 catalina:       "b3b0d80fb5caa9c4bcedb927c081bb9afc2cf12f016396c74800bc12a3228103"
    sha256 cellar: :any,                 mojave:         "1c37df365df42b7773727d6862320cec85bab17848caccb40f48521881f75a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e38b1fc605152b269ed94a2ce9b621d98f0fdff7afd41d2b26a37b4b976f14"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.10"

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
    assert_match "0e41270260895979317fff3898ab85668953aaa2", output
    assert_match "&waffle=liege", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
