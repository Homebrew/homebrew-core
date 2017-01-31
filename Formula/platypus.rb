class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "http://sveinbjorn.org/platypus"
  url "http://sveinbjorn.org/files/software/platypus/platypus5.1.src.zip"
  version "5.1"
  sha256 "7ff3a5e7c5a01603855e3294763d5603b90f8cfa100670771abc1097fd85fc7a"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d4301732ceb1fe105a0d98cf105adaf312b4fb14ed84398e137068336f992ba" => :sierra
    sha256 "7f1bcf04cdef0489799810a228697d144f5516df8a6e3145b6b0cdfb51acac3b" => :el_capitan
    sha256 "db54229624888569c9a9e5356e1a91ee141b96a257cab6f3230880938faf6d7f" => :yosemite
  end

  depends_on :xcode => ["7.0", :build]

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
      http://sveinbjorn.org/platypus

    Alternatively, install with Homebrew-Cask:
      brew cask install platypus
    EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
