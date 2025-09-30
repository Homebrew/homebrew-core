class Libdshconfig < Formula
  desc "Distributed shell library"
  homepage "https://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "https://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz"
  sha256 "6f372686c5d8d721820995d2b60d2fda33fdb17cdddee9fce34795e7e98c5384"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfort.gr.jp/~dancer/software/downloads/"
    regex(/href=.*?libdshconfig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "7d835c92dc8a1d1ce812a79d4fbbe8a900a77711f9a959362a1d03db8b7bfe8c"
    sha256 cellar: :any,                 arm64_sequoia:  "97fa8df11dd460eff2f15e043cd7529eae0fbbedb5f06419c1f05471381505eb"
    sha256 cellar: :any,                 arm64_sonoma:   "325b76dfad5d946aed984169514de5a4655307eab66db17e8b7109ef8759d87a"
    sha256 cellar: :any,                 arm64_ventura:  "3717933f302d4d371720ea523b77f0fccc3886c9f64e58b085fa8129b70eb2c2"
    sha256 cellar: :any,                 arm64_monterey: "d8ed328326850b16d0398cac9f951616fda597d084ded2363350a998d7105bfd"
    sha256 cellar: :any,                 arm64_big_sur:  "7c8ce322c8a67038c0d2eea98640665aad9a4f17dced7d796ac55e271936918a"
    sha256 cellar: :any,                 sonoma:         "7ba35555d2fccf06c7de51ae24455cbd3492cdb8f862aab21a12ac76095d7fb6"
    sha256 cellar: :any,                 ventura:        "bb3431f4d4aa5994f967ddfb94f567b46d5c5cef1a21ebd22731c6af71dc3f76"
    sha256 cellar: :any,                 monterey:       "80190054e7c4562cf68c8e13c09209a3667e06aca3af0e3b51d83adefc519d2d"
    sha256 cellar: :any,                 big_sur:        "aa368b8f973143fb64cb762956449fc29d978517519bc12c219351adaf0b9346"
    sha256 cellar: :any,                 catalina:       "eb5fb662035498062529345467af13234be5d022ccec9d2b3e2ad3437ff96e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6d07f65b30564eeab22a2f2e50f02fe6983ea927e381b1c1c398b044f456cb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad27e681ca7e49ff1b99f92fe3a62ecd6edd34bfb3fbc0f4f8cbc9ad386cc86"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Run autoreconf to regenerate the configure script and update outdated macros.
    # This ensures that the build system is properly configured on both macOS
    # (avoiding issues like flat namespace conflicts) and Linux (where outdated
    # config scripts may fail to detect the correct build type).
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdshconfig.h>
      int main(void) {
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldshconfig", "-o", "test"
    system "./test"
  end
end
