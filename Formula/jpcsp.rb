class Jpcsp < Formula
  desc "PSP emulator written in Java"
  homepage "https://jpcsp.org/"
  url "https://github.com/jpcsp/jpcsp.git", :revision => "9bf0cb72568e4c7170c6c5b0a975e0ff2f5205d1"
  version "0.7+20160322"
  head "https://github.com/jpcsp/jpcsp.git"

  bottle do
    cellar :any
    sha256 "21f906f30e0edee0e7883fba926f24b259714cf45b642f8d1337b858fb380217" => :mojave
    sha256 "ae41109bff3e00d7d62a2ed9bd29be94bad124a3cc1dfdec551bd1149ee4a83c" => :high_sierra
    sha256 "ef7a92493281cd2c18af2ec4d73a291c89f6e6e93613b71520ed6a3f067ae8f8" => :sierra
    sha256 "eb76d37c11b46c6ad7545456604aeba4efe127a213de2aab97cba3bd6d2de8f0" => :el_capitan
    sha256 "a6b330e246febab5a13181d4631c7e19d35a6173badaf7587586c8aa1a07af30" => :yosemite
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

  def caveats; <<~EOS
    ISO/CSO images are to be placed in the following directory:
      #{prefix}/Jpcsp.app/Contents/Resources/Java/umdimages

    To avoid any incidental wipeout upon future updates, change it to
    a safe location (under Options > Settings > General > UMD path folders).
  EOS
  end
end
