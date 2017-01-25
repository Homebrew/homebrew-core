class Imake < Formula
  desc "Build automation system written for X11"
  homepage "http://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.7.tar.bz2"
  sha256 "690c2c4ac1fad2470a5ea73156cf930b8040dc821a0da4e322014a42c045f37e"
  revision 2

  bottle do
    sha256 "6ca8c2397884a1a5bd629ce0a53a5c2152dca4d34ce99d5330fef7800a7f489d" => :el_capitan
    sha256 "14b73b74b8fdd51f8c214fd71bc03b09f18b3c915afb5b3fb506ed072080e530" => :yosemite
    sha256 "cc9a0a574ceb22feaf921194115fc211fa98b729eec8aa0985f6fa591efacc3d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on :x11

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/a0bb3a4/imake/patch-imakemdep.h.diff"
    sha256 "1f7a24f625d2611c31540d4304a45f228767becafa37af01e1695d74e612459e"
  end

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.5.tar.bz2"
    sha256 "ed23b85043edecc38fad4229e0ebdb7ff80b570e746bc03a7c8678d601be7ed4"
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
    system "#{bin}/imake", "--version"
  end
end
