class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20240728.tar.gz"
  sha256 "2d479817f95d5997fc4348ecebb1d8a1b25c81cebedb46ca4f59434247e08543"
  license "SMLNJ"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f2b9331555d9feaeaf4bf73c070c7bd50d7fd1517fad22935bba33314d02e053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a728d9ed877bfae84e267c64e81f09a511f3dd523bda31c7b0ec3a7076d6483f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b2e6af0767f18b30bde9bf047197aa8f861afe72b374892794993ecceaa4b2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f71f833d37dd5ec5d675afb9c770997547e360c40ccac159cddeecedf40493fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "08df642292e0e58a9f8ba843bad3006105f544ef4b23adfa7d8a692836c78c15"
    sha256 cellar: :any_skip_relocation, ventura:        "14169353ad436d7acc435813571a6df6153e722a7b72147d24921af0e69c5d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "37a1ff681d78a03940cf1fe2df53cfc3755edd8eecc6a50c3ab1fe85ac24253d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b4d84b57619e285f21b7f3cc8ed0550cd73fe047f4da676e23401c1ed7f12d"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
