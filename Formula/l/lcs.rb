class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  url "https://svn.code.sf.net/p/lcsgame/code/trunk", revision: "738"
  version "4.07.4b"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  # This formula is using an unstable trunk version and we can't reliably
  # identify new versions in this case, so we skip it unless/until it's updated
  # to use a stable version in the future.
  livecheck do
    skip "Formula uses an unstable trunk version"
  end

  bottle do
    sha256 arm64_tahoe:    "2a61e67dc07571f007602591630bd27ab9f7097b1fcec6de4f3d15bb9a28684b"
    sha256 arm64_sequoia:  "1b4eaae7da86c0a3882c11642d4dd5cdeac07f63742c7714e9cc1a57a88baf5b"
    sha256 arm64_sonoma:   "53c3857d8a8d4fbe45e84b0489f9a9b50da8078fc037f470473272ff36d7cb4d"
    sha256 arm64_ventura:  "af4b1c073592ae9b4f5f168b00c13fd02fddd09be18938c0d392812ae36a507b"
    sha256 arm64_monterey: "fe4700d7dbd9901cd46e1fdd19453b308d918391914bac529059b25f229b7bc9"
    sha256 arm64_big_sur:  "1ec069485376de05c00be777102bcef25f3f1349d84ecfc2e53990d6c6e403dd"
    sha256 sonoma:         "ad71dc194ad2f21f033c2415649ff165266aef24aa10f60c94f7add9f82256f2"
    sha256 ventura:        "3ee4e2b8a059045bf17d7d0b32860c1ec4ae23a996c9babf5a58efa0871659d6"
    sha256 monterey:       "a90a57e3001f38f79b787bbaad00e38099fcac09da06780f2996ae0666d80420"
    sha256 big_sur:        "9e3c6957bab58eaf828f8420fd7e493bb352544ec552c96eb24c8d1ec8d4adc6"
    sha256 catalina:       "65391613e5fd3ea3d8e5f7a2d5586105e3408bb09cddb77aebcfd4bcb7e3396a"
    sha256 arm64_linux:    "102e4a404dd5be9cd65c41bf4eb03c582c405037360447d381baa173d2e52f4e"
    sha256 x86_64_linux:   "ce3d505b47a5ada5e5b895876e51c224c3c716117c2f84e9853c05347ecddc4c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1403

    system "./bootstrap"
    libs = OS.mac? ? "-liconv" : ""
    system "./configure", "LIBS=#{libs}", "--prefix=#{prefix}"
    system "make", "install"
  end
end
