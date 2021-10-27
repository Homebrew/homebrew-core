class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  url "http://download.augeas.net/augeas-1.12.0.tar.gz"
  sha256 "321942c9cc32185e2e9cb72d0a70eea106635b50269075aca6714e3ec282cb87"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url "http://download.augeas.net/"
    regex(/href=.*?augeas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "136e012d7695d0ddf73a689d84b521aebc74944dc5b763b0f40abb2b49dff768"
    sha256 arm64_big_sur:  "9625e271fbbf7bb914bb7475eae95f97f99f5cbf9e71874f599ee620dd907432"
    sha256 monterey:       "62beef17116c12a01d5cf68595636570e658f3c9714b0601dc8884de458af419"
    sha256 big_sur:        "83b60962039b8d9c8a2ff343c8eaf21454976394f60ee5f340901d8de6161bd8"
    sha256 catalina:       "dc69497d1ac32d9f8203fb346965ad8e88f4498c120b7915a3f4dd0d7509d9e2"
    sha256 mojave:         "446030ec8931aa24eabee1e051daf7365dbd6fb9e43b4f71998dc6d7d0f9fdda"
    sha256 x86_64_linux:   "1d769bb0e887b5a321e5c89d15959e71fc7d616fb79c3e2e926ff2d1cefc106f"
  end

  head do
    url "https://github.com/hercules-team/augeas.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      # autoreconf is needed to work around
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44605.
      system "autoreconf", "--force", "--install"
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
