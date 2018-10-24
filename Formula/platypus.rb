class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://sveinbjorn.org/files/software/platypus/platypus5.2.src.zip"
  sha256 "0c0201804e13c09a33fe95ba715ed995872d35d3cdfa2cb694cf378980ed4c08"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "968362767410bc2055c0847543a95ba8a272a29015bd7c118ac47feeca12b649" => :mojave
    sha256 "598660d8723204958b3f891597408e24ef0ee1b6914037e9759949d20491290c" => :high_sierra
    sha256 "9b3b01e6a10711db553f8d59589701d1763f5d178a7c87496b0bc02d94a24f7b" => :sierra
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}/dst",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "clean",
               "install"

    man1.install "CommandLineTool/man/platypus.1"
    bin.install "dst/platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
      pkgshare.install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  def caveats; <<~EOS
    This formula only installs the command-line Platypus tool, not the GUI.

    The GUI can be downloaded from Platypus' website:
      https://sveinbjorn.org/platypus

    Alternatively, install with Homebrew Cask:
      brew cask install platypus
  EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
