class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.12/dhall-yaml-1.2.12.tar.gz"
  sha256 "e288091b568cfba756eb458716fb84745eb2599a848326b3eb3b45a5aa0008ea"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "124fc655cb7e13b6f0d560f16a13ac2c2f6f865f43b941997154b461b12a6737"
    sha256 cellar: :any,                 arm64_sequoia: "8bb4903a07a2b4f814993b70b5803d6d53226034c1e3cfaef567471af101de9f"
    sha256 cellar: :any,                 arm64_sonoma:  "d141b5f7a902b8f927e3ff1d5438cc6ec008b655613d6121b8f2980ef3373f0b"
    sha256 cellar: :any,                 arm64_ventura: "f54bf780f880756c5618e9535a87d459dcfbcb29e2a8d4e842862066ad9e8b14"
    sha256 cellar: :any,                 sonoma:        "aed714fe931e30297fc3acfe0812006a086c96037a884afb076448f188f291b6"
    sha256 cellar: :any,                 ventura:       "997efa948533b4b5d6d612ae012f6652224174fe87faca11929f04a807b956dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de44c119a5270dfa0282a7eb968249846819df806eee9b77b515414fcd200fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2733c1a7f981534bd06345135d759121a092faa84b36c64fff52c40800ca17"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = []
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
