class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://sveinbjorn.org/files/software/platypus/platypus5.2.src.zip"
  version "5.2"
  sha256 "0c0201804e13c09a33fe95ba715ed995872d35d3cdfa2cb694cf378980ed4c08"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11b199eb483328298a49792055306558182807fdf993b448c2f88145b57b14e0" => :sierra
    sha256 "edb6178b284a8701fb4e7e57ff57230269a774afc684776a557fa2572c2ac057" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "clean",
               "install"

    man1.install "CommandLineTool/man/platypus.1"

    cd buildpath

    bin.install "platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
      pkgshare.install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  def caveats; <<-EOS.undent
    This formula only installs the command-line Platypus tool, not the GUI.

    The GUI can be downloaded from Platypus' website:
      https://sveinbjorn.org/platypus

    Alternatively, install with Homebrew-Cask:
      brew cask install platypus
    EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
