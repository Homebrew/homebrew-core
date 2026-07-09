class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.12/dhall-yaml-1.2.12.tar.gz"
  sha256 "e288091b568cfba756eb458716fb84745eb2599a848326b3eb3b45a5aa0008ea"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "ab53adbde4511b5fc4bd6b3f4a3488e92ebfcb208aa7766c1c8a59dbf779685d"
    sha256 cellar: :any,                 arm64_sequoia: "6b2a02fc15c3abbfc04042d404073839367d304ffe8e99e3b71d3772d49a7669"
    sha256 cellar: :any,                 arm64_sonoma:  "4b63785bbc908ad5bd0ae2e4aad0682e149d8332fb4089fbe0a9bcd3935f52b5"
    sha256 cellar: :any,                 sonoma:        "360adbadc892b9de74c0a13d1fffc96b3d5ee5b616fd748cc89bb9e11a89f9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bacadaf5ffb007a013de69071aec868f42333dc142bfc408503319873333904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1a5d2074be5365245dca2f9fa478b07487fc3ebf11e4e1b0b29e86df3afe38"
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
