class Cdparanoia < Formula
  desc "Audio extraction tool for sampling CDs"
  homepage "https://www.xiph.org/paranoia/"
  url "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  sha256 "005db45ef4ee017f5c32ec124f913a0546e77014266c6a1c50df902a55fe64df"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/cdparanoia/?C=M&O=D"
    regex(/href=.*?cdparanoia-III[._-]v?(\d+(?:\.\d+)+)\.src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da6e298d56e612c17a306d5ce4ca383b17e73e1cf0c3361159c1c5361a311289"
    sha256 cellar: :any,                 arm64_ventura:  "5fce8011bf8533e069b7f6047defb5ef911f63ba9da06d6675091c97a7e7e227"
    sha256 cellar: :any,                 arm64_monterey: "5d8b1e73627d9349a554277257c4307708cb545241de318059226c30ddaff163"
    sha256 cellar: :any,                 arm64_big_sur:  "7f6df3210edceca8bc7efb2ad83d51bbb07df9d114dff57d0907f8a095eb6317"
    sha256 cellar: :any,                 sonoma:         "b29a6bdcc46159b6aebf0570b59478303e785447f42a1809fbef558c8175feee"
    sha256 cellar: :any,                 ventura:        "baa6da0e6a60da3c6a3417c48e967bee871661dcdd0fee3fa5d05463b0ae9623"
    sha256 cellar: :any,                 monterey:       "947c11b5f0535b78e5917e3c37ab1e1669bb5984df3e8a833656463a66a4bc9b"
    sha256 cellar: :any,                 big_sur:        "3254c96c3809aed7f6190abe33cfb95056532cc932de14591435e2dddb1d8cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b198eb38176c050af6da82d82ef25035dc43a1bfc94a02f064b9103b85a5593"
  end

  # see https://github.com/orgs/Homebrew/discussions/4154
  disable! date: "2024-02-21", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Patches via MacPorts
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/8e0aff2/cdparanoia/osx_interface.patch"
      sha256 "c4e22315b639535f41afd904188d8cc875e1642fcf59672c8b9ee06fc77e6b68"
    end
  end

  patch do
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bfad134/cdparanoia/linux_fpic.patch"
      sha256 "496f53d21dde7e23f4c9cf1cc28219efcbb5464fe2abbd5a073635279281c9c4"
    end
  end

  def install
    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    # RPATH to libexec on Linux must be added so that the linker can find keg-only libraries.
    unless OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}"
      inreplace "paranoia/Makefile.in",
                "-L ../interface",
                "-Wl,-rpath,#{Formula["cdparanoia"].libexec} -L ../interface"
    end

    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--libdir=#{libexec}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system bin/"cdparanoia", "--version"
  end
end
