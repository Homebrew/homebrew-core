class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.9/onig-6.9.9.tar.gz"
  sha256 "60162bd3b9fc6f4886d4c7a07925ffd374167732f55dce8c491bfd9cd818a6cf"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:mark|rev)\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53913ccbdad8ce504d0266fc20a867f2fc306d7331d066f2895f48d167102a24"
    sha256 cellar: :any,                 arm64_ventura:  "def0fa2c032e85b817ed3408867af987da1cafe3f2aa6aee2fb3c29df2d202d6"
    sha256 cellar: :any,                 arm64_monterey: "d0e0811b41b34a4fbbe65c9206b9969f8c469fca8cfe619caa7e5c74036921c3"
    sha256 cellar: :any,                 sonoma:         "75f2ef5b5593401d265669503cff50cda1fc10dbe2750fc54c87cbe578211b58"
    sha256 cellar: :any,                 ventura:        "5c4c16da729f311a12bd7863648b1c692fe502a0a3127eeb7460a47098c7a9a4"
    sha256 cellar: :any,                 monterey:       "86b7b52451edba60d365586a975d1eb40f7823992565dde5c88abb97fde483d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f0e52bb660582698f390023d5db08208ed468d2f01758018b9ee8c69aeba4f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
