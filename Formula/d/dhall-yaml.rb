class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.12/dhall-yaml-1.2.12.tar.gz"
  sha256 "e288091b568cfba756eb458716fb84745eb2599a848326b3eb3b45a5aa0008ea"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any, arm64_tahoe:   "76fee8c56a37bb080cec73ed60a3e0caf376ad2d1634349bdc4ef0b9b95200b9"
    sha256 cellar: :any, arm64_sequoia: "1c04b5b7d8fde10486c53a63de602b53333246c164d7aa276568e3455ed4f2b9"
    sha256 cellar: :any, arm64_sonoma:  "6fb29b3182aa625c6c2d2b81a646f79831befa4909b6d4bdad0080439e945323"
    sha256 cellar: :any, sonoma:        "4c08d93a9fd67b9c313dc6c52d14ec7557337d7593933c9f93ec717b4ff01e23"
    sha256 cellar: :any, arm64_linux:   "91a4b1c70ddc4ecc3a3520204266cefb72522a4d105afd60858b268f773b336a"
    sha256 cellar: :any, x86_64_linux:  "9658bf1ef952d504e6a8dd620bfa1fefc8791cb32a1449a856cf413f66ee66b4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    if build.stable?
      # Backport support for GHC 9.10
      args += ["--allow-newer=dhall-json:aeson", "--allow-newer=dhall-json:text"]
      inreplace "#{name}.cabal" do |s|
        # https://github.com/dhall-lang/dhall-haskell/commit/587c0875f9539a526037712870c45cc8fe853689
        s.gsub! "aeson                     >= 1.0.0.0   && < 2.2 ,",
                "aeson                     >= 1.0.0.0   && < 2.3 ,"
        # https://github.com/dhall-lang/dhall-haskell/commit/277d8b1b3637ba2ce125783cc1936dc9591e67a7
        s.gsub! "text                      >= 0.11.1.0  && < 2.1 ,",
                "text                      >= 0.11.1.0  && < 2.2 ,"
      end
    end

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
