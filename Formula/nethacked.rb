require "etc"

# Bugfixed and interface-patched Nethack.
#
# This formula is based on the Nethack formula, and includes the
# patches from same. The original notes from the Nethack formula
# follow:
# - @jterk
#
# Nethack the way God intended it to be played: from a terminal.
# This build script was created referencing:
# * https://nethackwiki.com/wiki/Compiling#On_Mac_OS_X
# * https://nethackwiki.com/wiki/Pkgsrc#patch-ac_.28system.h.29
# and copious hacking until things compiled.
#
# The patch applied incorporates the patch-ac above, the OS X
# instructions from the Wiki, and whatever else needed to be
# done.
# - @adamv

class Nethacked < Formula
  desc "Bugfixed and interface-patched Nethack"
  homepage "https://nethacked.github.io/"
  url "https://github.com/nethacked/nethacked/archive/1.0.tar.gz"
  sha256 "4e3065a7b652d5fc21577e0b7ac3a60513cd30f4ee81c7f11431a71185b609aa"
  license "NGPL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "e217165d22093bd7bd597ce198cba5de91a6e72fdee085ab9b4a1db3ce195c93"
    sha256 arm64_big_sur:  "6e72ef5f73856fce288298607152d9ffbd322d592b4d5f451739482e5d632aae"
    sha256 monterey:       "15bc192591e2f3ef2e007ce27f5462a6490ff0cb7d0bf430b91805cc671c2a16"
    sha256 big_sur:        "7ec798bfda16ed59639e13d8ec29a572f8ccb33be28f40eecbb1990ce7324454"
    sha256 catalina:       "619034420b0ce7a657824a14c45af647132ac8263839b9a56fc0b64ff100aa64"
    sha256 mojave:         "77cec385d3ab1ba8c9d4ef1234d25a42a7aff77c9db2158fad7820f677a67cc0"
    sha256 high_sierra:    "4fe2af842c20dc95f4ae5bebcffed0b85da6a94a548b0d5f8115d1829c80e3cc"
    sha256 sierra:         "d2c880eb02b32bc6a976b16502f400a94b395375b5cd59e731fb209580e3ceee"
    sha256 el_capitan:     "dcbe9a404fb0215e35dc9d08e73595ba8dadad55e6ca898078a66ce04c9dc11b"
    sha256 yosemite:       "08b24568c94b14271e5d1b2880a0a78e6eea5cbbabfb9519347b5be1d2cc0893"
    sha256 x86_64_linux:   "8575daddbf850b21652bef36c24a920f9c1ea9c72e7d92b9e6fdfa461c2f0c6e"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_macos do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b40e459/nethacked/1.0.patch"
      sha256 "d32bed5e7b4500515135270d72077bab49534abbdc60d8d040473fbee630f90f"
    end
  end

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    # Symlink makefiles
    system "sh", "sys/unix/setup.sh"

    inreplace "include/config.h",
      /^#\s*define HACKDIR.*$/,
      "#define HACKDIR \"#{libexec}\""

    # Enable wizard mode for the current user
    wizard = Etc.getpwuid.name

    inreplace "include/config.h",
      /^#\s*define\s+WIZARD\s+"wizard"/,
      "#define WIZARD \"#{wizard}\""

    inreplace "include/config.h",
      /^#\s*define\s+WIZARD_NAME\s+"wizard"/,
      "#define WIZARD_NAME \"#{wizard}\""

    # Only apply minor changes from the macOS patch needed for Linux to build.
    unless OS.mac?
      inreplace "src/Makefile", "-ltermlib", "-lncurses"
      inreplace "win/tty/termcap.c", "extern char *tparm();", "/*extern char *tparm();*/"
    end

    cd "dat" do
      # Make the data first, before we munge the CFLAGS
      system "make"
      %w[perm logfile].each do |f|
        touch f
        libexec.install f
      end

      # Stage the data
      libexec.install %w[help hh cmdhelp history opthelp wizhelp dungeon
                         license data oracles options rumors quest.dat]
      libexec.install Dir["*.lev"]
    end

    # Make the game
    ENV.append_to_cflags "-I../include"
    cd "src" do
      system "make"
    end

    bin.install "src/nethacked"
    (libexec+"save").mkpath

    # These need to be group-writable in multi-user situations
    chmod "g+w", libexec
    chmod "g+w", libexec+"save"
  end
end
