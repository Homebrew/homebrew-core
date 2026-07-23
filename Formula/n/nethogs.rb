class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5961bef2155c05695d2fe7e79aa11194981b5afd1cad9bf1f259c7f30d5487c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1092b122d659b8a17bdc48252e01474e4ef104e93c1c46424db33263b57563d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2242e689d96e298df5dd45c9d77829d4fba1354640421253a4b27e41c50490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9208b094733f623e93fd022bff00424ed5b1f780e95451a932ce4b1aea0fed72"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b09540da78113b3645bee43a9d267c7c4b093689a0fc8efc3ebeab3a041fdf0"
    sha256 cellar: :any,                 arm64_linux:   "cd62c0e39c0c54db13f3e4d9a6a7afdf728d3547e9882cea8c65d5c4142389f5"
    sha256 cellar: :any,                 x86_64_linux:  "9e57564f30bcb0672ea70837e2cd574c500bdb36eebc0051dcdf81320c634ccf"
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
