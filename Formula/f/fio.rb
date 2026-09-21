class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.42.tar.gz"
  sha256 "56b03497a918d07692257890fd759bf73168ad79df5be78a2bcbbdc8ce67895b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3af8fe1fd79c2f0af228bf7b26ff05318d8e25bed8562d376ac834e74cd7dbd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58e848c3df90d32bb612fab64ab2bf0687c68aec576586aa095e32ed436b7274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "081260c4fda9d5ef5cf55bd78b8b113584d8d4c74f4b75f0d102c35943493829"
    sha256 cellar: :any,                 arm64_linux:       "b604761a8ee4f26a9bb88ff7ad8cd7d4d9cfcc5551fae0c88499631c3ee3830f"
    sha256 cellar: :any,                 x86_64_linux:      "e05c2cb90955ee36734cb9f0fa9d81773fe721dee0be52d4456705fc5715ae4d"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "fiona", because: "both install `fio` binaries"

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
