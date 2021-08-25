class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://sveinbjorn.org/files/software/platypus/platypus5.3.src.zip"
  sha256 "b5b707d4f664ab6f60eed545d49a7d38da7557ce8268cc4791886eee7b3ca571"
  license "BSD-3-Clause"
  head "https://github.com/sveinbjornt/Platypus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f88009d8eb146080f0982ca92183e1a519958a92d299f40144e4a0cf67f2a560"
    sha256 cellar: :any_skip_relocation, big_sur:       "c774fbe0c5fdf4c13999f818a90709e5fa40af5ccd9b2479b2fdb393f61c08d0"
    sha256 cellar: :any_skip_relocation, catalina:      "8e1b66ba6d450ba4cef3ccd2192d58c08f1401a443a44338c80a917f7607341e"
    sha256 cellar: :any_skip_relocation, mojave:        "a08defbfae9f265bc7473c639b060fb8fa0dd1b6923746a1cf86756112347250"
    sha256 cellar: :any_skip_relocation, high_sierra:   "df48127dd7e77c37b7ed73247c74f3bb3d37d0e239590d848f91f8af5f98f628"
    sha256 cellar: :any_skip_relocation, sierra:        "d46dd428161d8ed7febf5ea4109f9bcddfa65c75d4e67619781745587c6b6f55"
  end

  depends_on xcode: ["8.0", :build]
  depends_on :macos

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

  def caveats
    <<~EOS
      This formula only installs the command-line Platypus tool, not the GUI.

      The GUI can be downloaded from Platypus' website:
        https://sveinbjorn.org/platypus

      Alternatively, install with Homebrew Cask:
        brew install --cask platypus
    EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
