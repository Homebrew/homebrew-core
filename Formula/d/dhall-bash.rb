class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-bash"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  stable do
    url "https://hackage.haskell.org/package/dhall-bash-1.0.41/dhall-bash-1.0.41.tar.gz"
    sha256 "2aeb9316c22ddbc0c9c53ca0b347c49087351f326cba7a1cb95f4265691a5f26"

    # Use newer metadata revision to relax upper bounds on dependencies for GHC 9.10
    resource "2.cabal" do
      url "https://hackage.haskell.org/package/dhall-bash-1.0.41/revision/2.cabal"
      sha256 "7284bb69b7b551c0c63dc83d2d797f1ec1666c7b9bcd6382cedeaac19e0975d3"
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "4fb3081bad01cadd586a5c854d846a416a527baaa8a05989c7af7d5d0e5fd6fe"
    sha256 cellar: :any, arm64_sequoia: "ea4efb44aee5cf5e0d170be78be628b64eec5313cf87411a8ce157e346b0866b"
    sha256 cellar: :any, arm64_sonoma:  "ba4d4b1defca7edcfc069a876bd847c293832715361fe59cdad5798e30cd3dd2"
    sha256 cellar: :any, sonoma:        "d544fd1a13eed9286ed6793f70befda6f4f6968fa7c4a55f555d2d9f027dd8df"
    sha256 cellar: :any, arm64_linux:   "a9567ba23790207ae16d0ba8dfaa40e23745647d97fbcf2ff4a53149d87a24f6"
    sha256 cellar: :any, x86_64_linux:  "17ce0dc8ae38906ee0469c8824ee2586d73eaee58a714764d3a644f1b568ecbb"
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
      odie "Remove resource and workaround!" if version > "1.0.41"
      resource("2.cabal").stage { buildpath.install "2.cabal" => "dhall-bash.cabal" }
      # https://github.com/dhall-lang/dhall-haskell/commit/dfa82861ed13796f6d7b96b30139a6f11e057e7b
      inreplace "#{name}.cabal", "text                      >= 0.2      && < 2.1",
                                 "text                      >= 0.2      && < 2.2"
    end

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    cd "dhall-bash" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
