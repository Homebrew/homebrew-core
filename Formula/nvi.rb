class Nvi < Formula
  desc "44BSD re-implementation of vi"
  homepage "https://sites.google.com/a/bostic.com/keithbostic/vi/"
  url "https://deb.debian.org/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz"
  sha256 "8bc348889159a34cf268f80720b26f459dbd723b5616107d36739d007e4c978d"
  revision 5

  bottle do
    cellar :any
    sha256 "433ad12463c8b8f36f78295307d75b9886799b9dd924e2e483667c302a7a8b47" => :catalina
    sha256 "b5ccb501038dfbb0e14241a2f5efe0c731e05ca0adc2690a473178252f5c0313" => :mojave
    sha256 "dcaa5dd43e6edfc5c8188761cc8aad6b80a06abc7382b8ceac4d92498354b5c4" => :high_sierra
    sha256 "1327ea05ec82ec05e9ec7b00b95ac3f7329b198a613385042a0814265b393f13" => :sierra
    sha256 "e188b0a9fa040c6a11f7ed6338d28d96428e11cfa019aaa1d0aa69e0f2b87bc3" => :el_capitan
  end

  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
  depends_on "berkeley-db"

  uses_from_macos "ncurses"

  # Patches per MacPorts
  # The first corrects usage of BDB flags.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8ef45e8b/nvi/patch-common__db.h"
    sha256 "d6c67a129cec0108a0c90fd649d79de65099dc627b10967a1fad51656f519800"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8ef45e8b/nvi/patch-dist__port.h.in"
    sha256 "674adb27810da8f6342ffc912a54375af0ed7769bfa524dce01600165f78a63b"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8ef45e8b/nvi/patch-ex_script.c.diff"
    sha256 "742c4578319ddc07b0b86482b4f2b86125026f200749e07c6d2ac67976204728"
  end

  # Upstream have been pretty inactive for a while, so we may want to kill this
  # formula at some point unless that changes. We're leaning hard on Debian now.
  patch do
    url "https://deb.debian.org/debian/pool/main/n/nvi/nvi_1.81.6-13.debian.tar.xz"
    sha256 "306c6059d386a161b9884535f0243134c8c9b5b15648e09e595fd1b349a7b9e1"
    apply "patches/03db4.patch",
          "patches/19include_term_h.patch",
          "patches/24fallback_to_dumb_term.patch",
          "patches/26trailing_tab_segv.patch",
          "patches/27support_C_locale.patch",
          "patches/31regex_heap_overflow.patch"
  end

  def install
    cd "dist" do
      system "./configure", "--prefix=#{prefix}",
                            "--program-prefix=n",
                            "--disable-dependency-tracking"
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
