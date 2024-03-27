class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.37.tar.gz"
  sha256 "b59099d42d5c62a8171974e54466a688c8da6720bf74a7f16bf24fb0e51ff92d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fa5f29acbc4d39001de9c520d6e638e4e8e7ed2b9f7261c3edccffaf5da20d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61aecb471bfb1d8f1f9c8b5a97414dabc957130d8b2d18ac0491c63c391b5be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e33797ea700cd1e2b463cb2df302d489ce56a1069c41cbcd4da1943c8502db"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfc26c572616aef25c16711be4c15c8c882f8f52dfd5cfa311ec9c5e033d3206"
    sha256 cellar: :any_skip_relocation, ventura:        "b3c0ed99e6ce9210a06f8613610eff0bdecec2501eb53162645107e9bdbfe88d"
    sha256 cellar: :any_skip_relocation, monterey:       "0047937e6a1b4e1988046b0b331ffc0795b4824a9a8a835406c7160e23ac263c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d792563e51ac3ae90c3b8540995cac1d3e49a0636eae52a62afe7537b887e3f"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
