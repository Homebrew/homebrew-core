class Nvi < Formula
  desc "44BSD re-implementation of vi"
  homepage "https://repo.or.cz/nvi.git"
  url "https://deb.debian.org/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz"
  sha256 "8bc348889159a34cf268f80720b26f459dbd723b5616107d36739d007e4c978d"
  license "BSD-3-Clause"
  revision 6

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nvi/"
    regex(/href=.*?nvi[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "aa9ca9f2bf556b19378cc59734101a3fd3ae96a4221589f4c39f0a2690c25e3e"
    sha256 cellar: :any,                 arm64_sequoia:  "4dadb4e9103dae1a849b5bd29bb0a4fb66a66ae99302541fca056fe4cd305770"
    sha256 cellar: :any,                 arm64_sonoma:   "c78ea8a45f937c0918dbbceeb33112139f86dd8c2d6c2aa12517289c3f88a7d9"
    sha256                               arm64_ventura:  "aa6ba856388d331dce1cec171db093a6846d349d3b0013bd08c3331d9d6f09f1"
    sha256                               arm64_monterey: "4172bb7673685b0e0f569ad84edbe4d568c152b419678e6146f539accd243c80"
    sha256                               arm64_big_sur:  "0c504c79f2fd0be54ce31ee4236a1d9fb4d9e5d8f33fab07305e1acd9c4740de"
    sha256 cellar: :any,                 sonoma:         "b471e00997873dd4a5b2841487af7ba9a403e1eb803aeab7d2326c27f1bc9b73"
    sha256 cellar: :any,                 ventura:        "c7836fbb451c44095dec64bb0cac55e1b95829cca063201988a45eee538fcd09"
    sha256 cellar: :any,                 monterey:       "4bbbf70becf3cfa52340027bb81f0b39b8071638dcb9f042cf314bee7a8feeac"
    sha256 cellar: :any,                 big_sur:        "692b129c29e7018565decb9c3ece80c020028549eb571d638851bb0e8647b0d8"
    sha256 cellar: :any,                 catalina:       "9443eb6edf1377a25a506245df2a20c0d2a7365d71eee720bb7152052b96d3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77dc49d28cfd69d761ae59838253f8ee295a2f966eacd89ca3e3d4b2499e890a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8eb6c0c8a8eef36a09bf55e35ced6d2e2afb4d75a70d93d96e88d9cbd5c4b56"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
  depends_on "berkeley-db@5"

  uses_from_macos "ncurses"

  # Patches per MacPorts
  # The first corrects usage of BDB flags.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/nvi/patch-common__db.h"
    sha256 "d6c67a129cec0108a0c90fd649d79de65099dc627b10967a1fad51656f519800"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/nvi/patch-dist__port.h.in"
    sha256 "674adb27810da8f6342ffc912a54375af0ed7769bfa524dce01600165f78a63b"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/nvi/patch-ex_script.c.diff"
    sha256 "742c4578319ddc07b0b86482b4f2b86125026f200749e07c6d2ac67976204728"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/a0cae35e9fce0f3d591af204ff72aa0a98606d05/editors/nvi/files/patch-common_key.h.diff"
    sha256 "3f923f33b98c90a5f96b7e8853d753871abcf93acd75052964ade2d9574502c5"
  end

  # Upstream have been pretty inactive for a while, so we may want to kill this
  # formula at some point unless that changes. We're leaning hard on Debian now.
  patch do
    url "https://deb.debian.org/debian/pool/main/n/nvi/nvi_1.81.6-17.debian.tar.xz"
    sha256 "4f81fa274e71093d212ca981dc510e9bf2f1d4716f3c447ec2402607aa394bca"
    apply "patches/03db4.patch",
          "patches/19include_term_h.patch",
          "patches/20glibc_has_grantpt.patch",
          "patches/24fallback_to_dumb_term.patch",
          "patches/26trailing_tab_segv.patch",
          "patches/27support_C_locale.patch",
          "patches/31regex_heap_overflow.patch"
  end

  def install
    cd "dist" do
      # Run autoreconf on macOS to rebuild configure script so that it doesn't try
      # to build with a flat namespace.

      # These files must be present for autoreconf to work.
      %w[AUTHORS ChangeLog NEWS README].each { |f| touch f }
      system "autoreconf", "--force", "--install", "--verbose"

      # Xcode 12 needs the "-Wno-implicit-function-declaration" to compile successfully
      # The usual trick of setting $CFLAGS in the environment doesn't work for this
      # configure file though, but specifying an explicit CC setting does
      system "./configure", "--program-prefix=n",
                            "CC=" + ENV.cc + " -Wno-implicit-function-declaration -Wno-incompatible-pointer-types",
                            *std_configure_args
      system "make"
      ENV.deparallelize
      system "make", "install"
    end
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/nvi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
