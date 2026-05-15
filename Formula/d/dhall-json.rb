class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.12/dhall-json-1.7.12.tar.gz"
  sha256 "ca48cd434380cbd979dbb12889f90da8fdc1ea90bc266cab14f061c60e19d5fa"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "5b790ced1db4fd7941d3bf402dd5b24fc89ed2dfd878d29475bb344da661296e"
    sha256 cellar: :any,                 arm64_sequoia: "3ff0895f95e1bfce054ad771de2e0003d8a28f5b122b24a4b7d0ef9af4b64a1e"
    sha256 cellar: :any,                 arm64_sonoma:  "8d50f129fd2de08651d0236d9a874df0d4248cfa3c91a7d075b8e50be76cd838"
    sha256 cellar: :any,                 sonoma:        "8da9034586421f58ba9b51df7ac5ff0fa11175741d2805e6e4b2d3e8e273910b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9e495a9250e2373cc89392183c27f7d4efd4c4ddd60b4a1756f8e0bc7e0c80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef938910ed4727970c8f3bd2ca25e2610ecaaf41d1b2de45bf9176fb83f7975e"
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
    if build.stable?
      # Backport support for GHC 9.10
      inreplace "#{name}.cabal" do |s|
        # https://github.com/dhall-lang/dhall-haskell/commit/28d346f00d12fa134b4c315974f76cc5557f1330
        s.gsub! "aeson                     >= 1.4.6.0   && < 2.2 ,",
                "aeson                     >= 1.4.6.0   && < 2.3 ,"
        # https://github.com/dhall-lang/dhall-haskell/commit/277d8b1b3637ba2ce125783cc1936dc9591e67a7
        s.gsub! "text                      >= 0.11.1.0  && < 2.1 ,",
                "text                      >= 0.11.1.0  && < 2.2 ,"
      end
    end

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    cd "dhall-json" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
