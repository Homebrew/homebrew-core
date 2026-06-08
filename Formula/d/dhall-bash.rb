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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "7f274ea970c65fd534fc7d341376d42b84b24ca994af99b98bab41e14cbe1be5"
    sha256 cellar: :any,                 arm64_sequoia: "2f2fd79aa19aa70ee8d45f2ed0f78473063d9cfd9d308d32cebeab1bee56a9b5"
    sha256 cellar: :any,                 arm64_sonoma:  "719ba58654cb84ab5dae98d554e6124363f0c8582c36c621d9ed26e781a167a7"
    sha256 cellar: :any,                 sonoma:        "bd81c8c4264ef63efcdd07c59d87d413a83b83f140ef737e114eec5db7b851fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0077fb6556ff60d8ff7fdd9ed89cc52424567bc03089237d588d8b9edb7ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce078653ce0eba7af9a386dea3090b7fbd36c141a08b8eb5cfff1197a77b971f"
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
