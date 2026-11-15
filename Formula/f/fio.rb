class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.43.tar.gz"
  sha256 "efa49b3f36eda9adf29294f27a87d7e457747d676cd0f73996d6365357832cfe"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b7197238360929e9f2b3ba6d2fb8e359061dc07dd23a055405440ae9991fe91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1f4fa60ee65027f3689aa11fe168bde90ffc169c20a92625a18ca6454474b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f18f3fa32b5893cc37db51000a8c52ca2b01fadea876a3de006c50307e89a77"
    sha256 cellar: :any,                 arm64_linux:       "38c2bf604b600681233a88c987ed04480bd86ebe85ec3e202ed7d40d4565f3ab"
    sha256 cellar: :any,                 x86_64_linux:      "0a1b798a44a7027561385f294a36a2710ad163d378ea4caa89442a9978e38e3a"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "fiona", because: "both install `fio` binaries"

  deny_network_access!

  def install
    # fio's configure script passes `-march` flags as part of detecting CRC
    # support on ARM. By default brew's logic removes such flags, resulting
    # in the prope falsely succeeding (probes compile when they shouldn't)
    # and `ARCH_HAVE_CRC_CRYPTO` being enabled when it shouldn't, giving a
    # compile time failure later in the build.
    # Solve by enabling `runtime_cpu_detection` which configures brew not
    # to strip those flags, so the configure probe fails correctly when it
    # should.
    ENV.runtime_cpu_detection
    # fio's' configure script enables `-march=native` by default. Disable
    # this to ensure binaries are portable. Ordinarily brew's logic would
    # remove `-march` flags by default - but we disabled that above.
    system "./configure", "--disable-native"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system bin/"fio", "--parse-only"
  end
end
