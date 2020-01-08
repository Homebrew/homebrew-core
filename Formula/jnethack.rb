require "etc"

# Nethack the way God intended it to be played: from a terminal.
# This formula is based on Nethack formula.

class Jnethack < Formula
  desc "Japanese localization of Nethack"
  homepage "https://jnethack.osdn.jp/"
  url "https://downloads.sourceforge.net/project/nethack/nethack/3.4.3/nethack-343-src.tgz"
  version "3.4.3-0.11"
  sha256 "bb39c3d2a9ee2df4a0c8fdde708fbc63740853a7608d2f4c560b488124866fe4"

  bottle do
    sha256 "22c77a0b903452c595e324b04dc5cf09d37fa56af922fc438e8aad3e4899082d" => :catalina
    sha256 "54890df9ae6c932ed1ec36deb7892e5ddd28857e3740dd0c36f9d20f231caf3d" => :mojave
    sha256 "7422717258f234810d99d330df0a0e99b90da7328db9324a92d39a63869e008b" => :high_sierra
    sha256 "89c2fed343614d39084a8c59908032fe929e78c1572e92f50b9eafa4aca3860d" => :sierra
    sha256 "c11837932635f89762360ad449e189c44e8213cb74f981ccb7908671a0e3ad4b" => :el_capitan
    sha256 "f0c7c0c5bbf5c7d5b2d733fd76d49f31039b15c982a7ef7530444f734a41ec7c" => :yosemite
  end

  # needs X11 locale for i18n
  depends_on :x11

  # Don't remove save folder
  skip_clean "libexec/save"

  patch do
    # Canonical: https://osdn.net/dl/jnethack/jnethack-3.4.3-0.11.diff.gz
    url "https://dotsrc.dl.osdn.net/osdn/jnethack/58545/jnethack-3.4.3-0.11.diff.gz"
    sha256 "fbc071f6b33c53d89e8f13319ced952e605499a21d2086077296c631caff7389"
  end

  # Patch from MacPorts' jnethack portfile
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e9653f1/jnethack/3.4.3-0.11.patch"
    sha256 "6340de3784ee7b4d35fcf715ebbf08ec8e20214b0c2ae53f9c717afdae467c46"
  end

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    ENV["HOMEBREW_CFLAGS"] = ENV.cflags

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

    cd "dat" do
      system "make"

      %w[perm logfile].each do |f|
        touch f
        libexec.install f
      end

      # Stage the data
      libexec.install %w[jhelp jhh jcmdhelp jhistory jopthelp jwizhelp dungeon license data jdata.base joracles options jrumors.tru jrumors.fal quest.dat jquest.txt]
      libexec.install Dir["*.lev"]
    end

    # Make the game
    ENV.append_to_cflags "-I../include"
    cd "src" do
      system "make"
    end

    bin.install "src/jnethack"
    (libexec+"save").mkpath
  end
end
