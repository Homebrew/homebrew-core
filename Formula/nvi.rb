class Nvi < Formula
  desc "44BSD re-implementation of vi"
  homepage "https://sites.google.com/a/bostic.com/keithbostic/vi/"
  url "https://deb.debian.org/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz"
  sha256 "8bc348889159a34cf268f80720b26f459dbd723b5616107d36739d007e4c978d"
  revision 5

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "04c6e757e06a8aa9b886c167d2fd2fafb31a9f51c98bb2999984aa677f2fcecb"
    sha256                               arm64_big_sur:  "fb16c60c3a71af91e1bfec9f01bd35a11844f02a50e18e7782a20f5eb2792874"
    sha256 cellar: :any,                 monterey:       "affc8a0a4d2adbeda560b55565c47e6dda352e94c11c4dcb0a544ea7e8ccfe17"
    sha256 cellar: :any,                 big_sur:        "91d13cdd8ff35675b7d54a7cc29a2406a9fcc183e03484ee1a0cd781bca160b9"
    sha256 cellar: :any,                 catalina:       "755290657397d76ae23d23636a6d9469447bcbc3dead65ec2859a8f9b7071f88"
    sha256 cellar: :any,                 mojave:         "03eb1d6e82bb75219ce378e47956fc3b50ef2096e715eec42e37bcf14cde8cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44c36f27b543554fe6f22002ae584fb2b599cc7e27213ef2695de416203688c"
  end

  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
  depends_on "berkeley-db"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
      # Run autoreconf on macOS to rebuild configure script so that it doesn't try
      # to build with a flat namespace.
      if OS.mac?
        # These files must be present for autoreconf to work.
        %w[AUTHORS ChangeLog NEWS README].each { |f| touch f }
        system "autoreconf", "--force", "--verbose", "--install"
      end

      # Xcode 12 needs the "-Wno-implicit-function-declaration" to compile successfully
      # The usual trick of setting $CFLAGS in the environment doesn't work for this
      # configure file though, but specifying an explicit CC setting does
      system "./configure", "--prefix=#{prefix}",
                            "--program-prefix=n",
                            "--disable-dependency-tracking",
                            "CC=" + ENV.cc + " -Wno-implicit-function-declaration"
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
