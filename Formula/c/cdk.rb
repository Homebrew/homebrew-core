class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20260119.tgz"
  sha256 "46bb68441e698a7b1f642e2564968a7700afef0386442afd5cf2e7b296d30ee5"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1385097ea494ad07851d2830e58c15c855f9094dcbc157b9fa2e9eb2ca271158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10688c9b60cd822682777a74a62e3c93b6a143e8fbe1bf82217d343b7c2c586d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93a18729ac014cac89aeb755cf9a67574070da419a2db7811608a223018f5540"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede3ad78d7a04193d0635ce068803cbdbc10f851229d6d17a44767f96f972923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb3f98579f8ed1542c61e78a0c9edab8c50f3f0ce2947ca58b075ba5653f928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03b43b5924c1c6400f9e61b688e259acc265c6c1e76c16d6c327fb14497dfb9"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
