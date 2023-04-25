class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.7.2.tar.gz"
  sha256 "0545b792e81f5edd51a2fdfbfcc4eac7ba8087005811ab41c34bfac4d78fe926"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "bcd7a9b774976dbb97d73fb1a93b36b7c5abc8579d7a303ccd78f86bd2fa7790"
    sha256 arm64_monterey: "40f2b32ea38db9b88c01d83ee1bcc6ff70528abd3e0097120a3396674d7e03ab"
    sha256 arm64_big_sur:  "3e25963361c30a566a9bc39b67d69621509685a8878e91e01c442fd6cd397479"
    sha256 ventura:        "10ef900bfcd6602875c14281ead4b3d6c7c745b775a748cfe3a9b692a3606dac"
    sha256 monterey:       "11493b60f774efe3499cf527745f82761ee3eead78d9dc0d1af49a48ecf2bd70"
    sha256 big_sur:        "52933a62e14d28198597e492ae63dae43e5b32ee00fbbdf4981a8356afce9cc9"
    sha256 x86_64_linux:   "d848913d75859dd4811c2ae6e608a249a5d3872c23058113fb7ea1dfdbb64486"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--enable-readpcap", "LEXLIB="
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
