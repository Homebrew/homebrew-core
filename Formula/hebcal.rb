class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.27.tar.gz"
  sha256 "a69913029933fccc187ad1243bf57a7e799ce06b8f3d813174af3c8d78054b14"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef2840dc129e54f7c8de879425afdc8065b1f2a23bbba450bad4f31e7e017dfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f57d2efad311c08cea9da55e4963db401a6519b9467ed3eda0c9cbf8f8f3ff8"
    sha256 cellar: :any_skip_relocation, monterey:       "0e9f5260285848d25f3e7153326b7e248d7908b17416426cdc8cd5c9acd9ca88"
    sha256 cellar: :any_skip_relocation, big_sur:        "b813b65f6d22d113b0298d7cf022ab747da2fa4b29384d98226c8374d9fd6105"
    sha256 cellar: :any_skip_relocation, catalina:       "d9d9784bed036a9a2c95eea5267dfb54e9229c164a8d2bd0bae1157b2b4089e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edede749c9c260869e8bf282dfa318047efbe5947349e6e6bcb8164fb4c5abe6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "gperf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
