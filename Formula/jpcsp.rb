class Jpcsp < Formula
  desc "PSP emulator written in Java"
  homepage "http://jpcsp.org/"
  url "https://github.com/jpcsp/jpcsp.git", :revision => "9bf0cb72568e4c7170c6c5b0a975e0ff2f5205d1"
  version "0.7+20160322"
  head "https://github.com/jpcsp/jpcsp.git"

  bottle do
    cellar :any
    sha256 "cdfd6715e70f271ee1df320a230951edcc173bb9d70c84298c1665c4c64c868c" => :el_capitan
    sha256 "68861093a2cb32f11c6769abca9e718b404547824f86f14eb7564ae65dfc4f4a" => :yosemite
    sha256 "d04a5ffea0538bc056a009e307343a05cc06f3e53cac6125c5916c31b44953f3" => :mavericks
  end

  depends_on "ant" => :build
  depends_on "p7zip" => :build
  depends_on :java => "1.6+"

  def install
    system "ant", "-f", "build-auto.xml", "dist-macosx"
    chmod 0755, "dist/jpcsp-macosx/Jpcsp.app/Contents/MacOS/JavaApplicationStub"
    prefix.install "dist/jpcsp-macosx/Jpcsp.app"
    bin.write_exec_script "#{prefix}/Jpcsp.app/Contents/MacOS/JavaApplicationStub"
    mv "#{bin}/JavaApplicationStub", "#{bin}/jpcsp"
  end

  def caveats; <<-EOS.undent
    ISO/CSO images are to be placed in the following directory:
      #{prefix}/Jpcsp.app/Contents/Resources/Java/umdimages

    To avoid any incidental wipeout upon future updates, change it to
    a safe location (under Options > Settings > General > UMD path folders).
    EOS
  end
end
