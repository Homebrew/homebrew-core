class Lame < Formula
  desc "High quality MPEG Audio Layer III (MP3) encoder"
  homepage "https://lame.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lame/lame/4.0/lame-4.0.tar.gz"
  sha256 "3df5124d5ad3a98312ffd7ba6a9b36230e4f8a3e66d3ce0f425e336c32d216eb"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/lame[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0fe0cfb39c74a53b7635833fe3293a62c886b084bc5ccc8ed7cd177803182e4"
    sha256 cellar: :any, arm64_sequoia: "552d24d56ff0d3255e9a3519a368d0ce45de86b5b2967b338209c1a22cd12969"
    sha256 cellar: :any, arm64_sonoma:  "b0cfa1500aff96430c865fa5e3e8b5494bb9ff70dd4f4fe8f9e7684da626649a"
    sha256 cellar: :any, sonoma:        "62e5e6acdb340cfdae39e4a4ad49e8b2efcd46bfe91897b670a2c0d5a0693c19"
    sha256 cellar: :any, arm64_linux:   "bd3d4df9fd0722b758bea12328bd1345d2ca507842f4074b88fe5d10cae13b73"
    sha256 cellar: :any, x86_64_linux:  "260e9309ef40e8ad7373bfae07f20d5357e036d32b14ea3ce6526fdf15181a37"
  end

  depends_on "pkgconf" => :build
  depends_on "mpg123"

  uses_from_macos "ncurses"

  def install
    # LAME still calls undeclared legacy ID3 APIs, which do not compile as C23.
    # https://sourceforge.net/p/lame/bugs/517/
    ENV["ac_cv_prog_cc_c23"] = "no"
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end

  test do
    system bin/"lame", "--genre-list", test_fixtures("test.mp3")
  end
end
