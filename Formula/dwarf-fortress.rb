class DwarfFortress < Formula
  desc "Open-ended roguelike game"
  homepage "http://bay12games.com/dwarves/"
  url "http://www.bay12games.com/dwarves/df_43_05_osx.tar.bz2"
  version "0.43.05"
  sha256 "c9614c012c23dcef6197f83d02510d577e1257c5a0de948af5c8f76ae56c5fc8"

  bottle do
    cellar :any
    sha256 "a9005bf26f7bc443fa4ecc63d663b9478f26464e020e02664eb6254cdd80d527" => :el_capitan
    sha256 "980ad47fd09378f5cc3c514fca2e73b50b077760d3ec75863d9b6d2df42fba04" => :yosemite
    sha256 "8401db4e3b92579272b4b4ff9f119d67d17b7804bd4d61aaeafdb7eb653eeb15" => :mavericks
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
