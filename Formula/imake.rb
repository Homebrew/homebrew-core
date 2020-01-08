class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.8.tar.bz2"
  sha256 "b8d2e416b3f29cd6482bcffaaf19286d32917a164d07102a0e531ccd41a2a702"
  revision 1

  bottle do
    sha256 "1a574a4c8ceca83d91e73ab77b92c591443dab31822cda9f81e71bde30181a68" => :catalina
    sha256 "ac21eb715eb1287107b2ce1a17b1603f84621f763e7fcbbb9a570c5591afcd79" => :mojave
    sha256 "393c0d8de751664235eb1683351bf78dec4a65d731ffdff2afd544ad854b3ebb" => :high_sierra
    sha256 "3a08e1b5dc7b24286dc06a10ef792c09c7ce2b9f588418c180ee67d57bf2874f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on :x11

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.6.tar.bz2"
    sha256 "4dcf5a9dbe3c6ecb9d2dd05e629b3d373eae9ba12d13942df87107fdc1b3934d"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/a0bb3a4/imake/patch-imakemdep.h.diff"
    sha256 "1f7a24f625d2611c31540d4304a45f228767becafa37af01e1695d74e612459e"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    cpp_program = Formula["gcc"].opt_bin/"cpp-#{Formula["gcc"].version_suffix}"
    inreplace "imakemdep.h", /::CPPCMD::/, cpp_program
    inreplace "imake.man", /__cpp__/, cpp_program

    # also use gcc's cpp during buildtime to pass ./configure checks
    ENV["RAWCPP"] = cpp_program

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    resource("xorg-cf-files").stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{MacOS::X11.include}"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    # Use pipe_output because the return code is unimportant here.
    output = pipe_output("#{bin}/imake -v -s/dev/null -f/dev/null -T/dev/null 2>&1")
    gcc_major_ver = Formula["gcc"].version_suffix
    assert_match "#{Formula["gcc"].opt_bin}/cpp-#{gcc_major_ver}", output
  end
end
