class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.12.7.tar.gz"
  sha256 "5326ed7ee95ef18039390c0b17891ac28985ac7c7a4235070fab767c1fe37bd8"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "466e5845fdc550a3e6cadffa34dda10eaf0f2954ee10c48c18c1508d2d277fb9"
    sha256 arm64_tahoe:       "d67b31364db4f454b5332d24c058ea32c91f0204428867e0cb13651e13d37e64"
    sha256 arm64_sequoia:     "1708588d6856fa1e5051ac53a8f3868449dd278c4cc99942824d8cfd427da10e"
    sha256 arm64_linux:       "d816224b698bc8006f51815ebbfef233c264e9d36f877298aeff350fdc8f3e06"
    sha256 x86_64_linux:      "d9885d23745a5e12a5f180ff4086b3b8a0558091ed54f009631e5546a4c1228b"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
