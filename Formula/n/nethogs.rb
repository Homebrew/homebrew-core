class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "111ade20cc545e8dfd7ce4e293bd6b31cd1678a989b6a730bd2fa2acc6254818"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02b72507de60a98acc43d6f939146777d65ed8ab2316bc66fec08f07cf2fbc24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63822d0cd7c0e15f8a7dc5df156f7802b23d2481007cb9fc683a14c8f9f78ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06a30ab6ab73071fd13b8655199f2bc0bc650c90240af29200f0a5dc681ced17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ea77a752e043dcf59afb915ae001663d57b3f9bdf829efe1202b90802e90b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "94cf8d3019a7b344781b52bfc4d0dec42580382e143a8a308faac8cfe13780d8"
    sha256 cellar: :any_skip_relocation, ventura:       "86e443cfcfb7f0956dfca5cc19282c525aff27f1c13be145360971e3161b251c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2646e3701644f65e25a1e8066ed374ac36fde0a8d86410e50da58cd7bcd3e46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e366aab4953f52e2978a45b72cf4467d87218a71370e5ea83efe72e096f265"
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append "CXXFLAGS", "-std=c++14"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
