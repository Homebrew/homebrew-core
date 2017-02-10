class DwarfFortress < Formula
  desc "Open-ended roguelike game"
  homepage "http://bay12games.com/dwarves/"
  url "http://www.bay12games.com/dwarves/df_43_05_osx.tar.bz2"
  version "0.43.05"
  sha256 "c9614c012c23dcef6197f83d02510d577e1257c5a0de948af5c8f76ae56c5fc8"

  bottle do
    cellar :any
    sha256 "13fb0099c9580a39226602194981e78eedead8a6b5711719c688d89158d37ece" => :sierra
    sha256 "13fb0099c9580a39226602194981e78eedead8a6b5711719c688d89158d37ece" => :el_capitan
    sha256 "13fb0099c9580a39226602194981e78eedead8a6b5711719c688d89158d37ece" => :yosemite
  end

  depends_on :arch => :intel

  def install
    # Dwarf Fortress uses freetype from X11, but hardcodes a path that
    # isn't installed by modern XQuartz. Point it at wherever XQuartz
    # happens to be on the user's system.
    system "install_name_tool", "-change",
                                "/usr/X11/lib/libfreetype.6.dylib",
                                "#{MacOS::XQuartz.prefix}/lib/libfreetype.6.dylib",
                                "libs/SDL_ttf.framework/SDL_ttf"

    (bin/"dwarffortress").write <<-EOS.undent
      #!/bin/sh
      exec #{libexec}/df
    EOS
    libexec.install Dir["*"]
  end
end
