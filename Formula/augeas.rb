class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1-or-later"
  head "https://github.com/hercules-team/augeas.git", branch: "master"

  stable do
    url "https://github.com/hercules-team/augeas/releases/download/release-1.13.0/augeas-1.13.0.tar.gz"
    sha256 "5002f33f42365ab78be974609a0f3b76a4c277fc404ec79f516305cab5ce5de1"

    # Replace deprecated 'security_context_t' with 'char *'. Remove in the next release.
    patch do
      url "https://github.com/hercules-team/augeas/commit/f38398a2d07028b892eac59449a35e1a3d645fac.patch?full_index=1"
      sha256 "1697379e0676edf94346a3377a75c871d1d0d033e3a37a29d69ae66f6e57553a"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "916e1603688af06ca325d7ecf378f379c82e88f3712d015e0874a560103d47de"
    sha256 arm64_monterey: "c2b38e9d3f4611a7d7c569ce62d19e35b6d9da3feb4706abddc27828fd4e2a09"
    sha256 arm64_big_sur:  "64fd8945d6a7408664bad5acc707e587f9c54a78fe3e320c57f13bf456c61553"
    sha256 ventura:        "b7b815ed1d01632344e3c77d7ab974115b1007958add8888edb44a5e9af7ccc3"
    sha256 monterey:       "8978eb7d972b143ab12e895b3fc72a4e9a12bd980e02e37eb0dadba9977d8fcd"
    sha256 big_sur:        "cb898760713b1cc45c6cfb24e8692e762037ca7d947b57d8d39fb89082681b7c"
    sha256 catalina:       "e3b262dfad73f3b6efb01ff258a465f566fd451377f0bf3bbe37a99f57926427"
    sha256 x86_64_linux:   "37c08a6a125569eb281a1a2812c44db90f529159418e9a0c5559697c634d2c65"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args
    else
      # autoreconf is needed to work around
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44605.
      system "autoreconf", "--force", "--install"
      system "./configure", *std_configure_args
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
