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
    sha256 cellar: :any,                 arm64_tahoe:    "fc061e1bd83501bfd964f4d38d83a650157e2c4933843c8b0423fa70c6f97732"
    sha256 cellar: :any,                 arm64_sequoia:  "9d68b83a58d01d235ccc302690fddd22413603e42beae2b8b909eaca8caab83b"
    sha256 cellar: :any,                 arm64_sonoma:   "ab39d342239cf90b5fd6395e5deec9e5664312a8b76d481973f61d7604c1d39b"
    sha256 cellar: :any,                 arm64_ventura:  "be2cc327743e9011455a4f318ea045968c6eb10632ebe6452194342e3a9fbb39"
    sha256 cellar: :any,                 arm64_monterey: "9d9db2d218e2627790aabf8e7cfd28f6722e039bbffb6f55505870098188e1d9"
    sha256 cellar: :any,                 arm64_big_sur:  "26d58c80e5db471ca253930300316cfc77dd1b53fae4ebd38502a48e69d4af8a"
    sha256 cellar: :any,                 sonoma:         "0ac4d83ebb4e63c5419e36794e292b7175553465919023ddc7225a04c8fbcc0e"
    sha256 cellar: :any,                 ventura:        "3e0363e363d1a596f674ed6c2f576f5f375c2ca61d43b17e336b67c4a3182597"
    sha256 cellar: :any,                 monterey:       "11ae6faf8f16faf3bc2be2f03981b4d1303897cfe86fb2108c05c4449cbafea6"
    sha256 cellar: :any,                 big_sur:        "dffadaeddcde173302400dfc71686048edf9944a3543ac578ce634d9f283870d"
    sha256 cellar: :any,                 catalina:       "6138b062f2a435928485795e2b3bdef81983a87137d4bf73029838f19c1210f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "230eb92e635d14a73da14fb444d5ebf116484e95ec8c0b8d3d80e893afa0b56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d711c147849e3de3f352052357765c5d55f82c005bde767c2ff3b95774c0d0"
  end

  depends_on "libevent"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", "--with-libevent=#{HOMEBREW_PREFIX}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "nylon: nylon version #{version}",
      shell_output("#{bin}/nylon -V 2>&1").chomp
  end
end
