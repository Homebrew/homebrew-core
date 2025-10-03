class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.12/dhall-json-1.7.12.tar.gz"
  sha256 "ca48cd434380cbd979dbb12889f90da8fdc1ea90bc266cab14f061c60e19d5fa"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "73baa2fd19be65be837a3c3309d7504e9d418eb7f0f339904eebb220966b603f"
    sha256 cellar: :any,                 arm64_sequoia: "39ad85b98a17ab00830ff951a371b3307f8f233b45515b5a8a4b508c7e26bf14"
    sha256 cellar: :any,                 arm64_sonoma:  "cb38db666618de2732dc9c6cfdc60011110896a4ecaf74a13c0d6154fd1e8c01"
    sha256 cellar: :any,                 arm64_ventura: "1f626e15918be89bc14f16ca825aed2b448b98b93170fc01ef1a3f53ae2cd7b6"
    sha256 cellar: :any,                 sonoma:        "f52f5df894456c02bf8b32e05a296fabe0526faaf79ecf024baf9507705b439e"
    sha256 cellar: :any,                 ventura:       "49846bb950d02b98c5640e93d527273a049d93445cfac3dfd01adf70a0036db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8df66ff7736b7d73de01bc9b317ccf7eae1527d28b8ea1a55b59630a4ee6aaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8791ac3d987c13ac8c904f876b01cdcf089e9aecc1476b101367df6621bcfa3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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

    cd "dhall-json" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
