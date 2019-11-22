class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://sveinbjorn.org/files/software/platypus/platypus5.3.src.zip"
  sha256 "b5b707d4f664ab6f60eed545d49a7d38da7557ce8268cc4791886eee7b3ca571"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e1b66ba6d450ba4cef3ccd2192d58c08f1401a443a44338c80a917f7607341e" => :catalina
    sha256 "a08defbfae9f265bc7473c639b060fb8fa0dd1b6923746a1cf86756112347250" => :mojave
    sha256 "df48127dd7e77c37b7ed73247c74f3bb3d37d0e239590d848f91f8af5f98f628" => :high_sierra
    sha256 "d46dd428161d8ed7febf5ea4109f9bcddfa65c75d4e67619781745587c6b6f55" => :sierra
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}/dst",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "CODE_SIGN_IDENTITY=", "CODE_SIGNING_REQUIRED=NO",
               "clean",
               "install"

    man1.install "CLT/man/platypus.1"
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
