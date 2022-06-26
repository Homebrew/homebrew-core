class Nylon < Formula
  desc "Proxy server"
  homepage "https://github.com/smeinecke/nylon"
  url "https://monkey.org/~marius/nylon/nylon-1.21.tar.gz"
  sha256 "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d9db2d218e2627790aabf8e7cfd28f6722e039bbffb6f55505870098188e1d9"
    sha256 cellar: :any,                 arm64_big_sur:  "26d58c80e5db471ca253930300316cfc77dd1b53fae4ebd38502a48e69d4af8a"
    sha256 cellar: :any,                 monterey:       "11ae6faf8f16faf3bc2be2f03981b4d1303897cfe86fb2108c05c4449cbafea6"
    sha256 cellar: :any,                 big_sur:        "dffadaeddcde173302400dfc71686048edf9944a3543ac578ce634d9f283870d"
    sha256 cellar: :any,                 catalina:       "6138b062f2a435928485795e2b3bdef81983a87137d4bf73029838f19c1210f5"
    sha256 cellar: :any,                 mojave:         "cb2cbfbd8df94b8581a116807075daf9fadbe9b9c5cfa537ea30dfa76537dd5c"
    sha256 cellar: :any,                 high_sierra:    "3df9b3197c8dc9a227221027047c8de77ddb6ad9ce2edd14544c2d6e4923b660"
    sha256 cellar: :any,                 sierra:         "b7eeab5896aaaca9c73166e519d092a71f15a36e800a28742729f8cbc270e6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d711c147849e3de3f352052357765c5d55f82c005bde767c2ff3b95774c0d0"
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libevent=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    assert_equal "nylon: nylon version #{version}",
      shell_output("#{bin}/nylon -V 2>&1").chomp
  end
end
