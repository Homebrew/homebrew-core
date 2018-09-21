class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.7.tar.bz2"
  sha256 "690c2c4ac1fad2470a5ea73156cf930b8040dc821a0da4e322014a42c045f37e"
  revision 4

  bottle do
    sha256 "744bc37ab36128960dc813cf1a07a25cf037595448c869f1ec41151542517419" => :mojave
    sha256 "f7b7121138f0c2d0d5c5dba574143f8c911b4be70538f1dbba4aeebe0dd5773f" => :high_sierra
    sha256 "1341c20e98ef8bd974202df0805c0ca9132eb436ff8e2e06624f1dd4c19094bc" => :sierra
    sha256 "941acafab09fe8afefe785eddce4565827de4f310494f783995b5035d95e5b4a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on :x11

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.5.tar.bz2"
    sha256 "ed23b85043edecc38fad4229e0ebdb7ff80b570e746bc03a7c8678d601be7ed4"
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
