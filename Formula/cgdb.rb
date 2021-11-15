class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.7.1.tar.gz"
  sha256 "bb723be58ec68cb59a598b8e24a31d10ef31e0e9c277a4de07b2f457fe7de198"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cgdb.me/files/"
    regex(/href=.*?cgdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e989548499ed3c13d5d176953e3ffcc2ad3ee81029194f78eee7c5ab512a316f"
    sha256 arm64_big_sur:  "c5eb8b69bec6303b69525db54266cf5f8125eb5b6d97d7f5c2bf41cdab082748"
    sha256 monterey:       "e85df3015c4d0ddf6a04909956f8e650aaa32928f94a6a55879fb52c8c2f6204"
    sha256 big_sur:        "dd7a9696d58a5d22b71f0fe2f749f89e6b0d660f0378829de3959a694a0bb007"
    sha256 catalina:       "50abc3a292d69a3a121f3ed7d54d72f4528eb1285faa7f842bb96588a463dc88"
    sha256 mojave:         "8f361fcad59ddf4825f4d42b516a099ba75bfffc0b885d42aeb875dbd1b2a1d4"
    sha256 high_sierra:    "9ab4c0a880cb71903094929b04eada3c279a48ddb00b651a8a93d55cd523d380"
    sha256 sierra:         "db6c63b20e2185ecaaf3ddef92d1ff052f0b0322c727f3f0429ef0d38ac9d269"
    sha256 x86_64_linux:   "f9e24f895766eaa03642f236edb3a102cdd12102134b6dd087790b8fbadb85c5"
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cgdb", "--version"
  end
end
