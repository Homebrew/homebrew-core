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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "16244660e90287842060815f5e5e0b3390e67a5dd18d0caa171edd9d61460666"
    sha256 cellar: :any,                 arm64_sequoia: "61d284e40933fe164546711dc5595f5e87fb234839fb56af80bbeb360d91700d"
    sha256 cellar: :any,                 arm64_sonoma:  "6220e81ec5cd70de07c1c7e43bdb590a0aea042298700168e6fcf6b854ba9d8f"
    sha256 cellar: :any,                 arm64_ventura: "9e5096f50c89403fabf0797203289e090af5173c8350cc265e5e59268cece9e8"
    sha256 cellar: :any,                 sonoma:        "0ab1b570e3c1d868934221ae92b23a84f314ee4d51c4ebd3272163488999673e"
    sha256 cellar: :any,                 ventura:       "77529ea2f79316fd15f32850c35aae0a810ed7e38ce5c17762c4d6316be06f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf43c06b2e19ca68f0de41e156d16e9e05a98a036fc9b3236b2bcb7720b0405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7711cbba94bfdb4287d80b936ced23f59c77c33fd2225c86b4ecec931d1fd5"
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
      odie "Remove resource and workaround!" if version > "1.0.41"
      resource("2.cabal").stage { buildpath.install "2.cabal" => "dhall-bash.cabal" }
      # https://github.com/dhall-lang/dhall-haskell/commit/dfa82861ed13796f6d7b96b30139a6f11e057e7b
      inreplace "#{name}.cabal", "text                      >= 0.2      && < 2.1",
                                 "text                      >= 0.2      && < 2.2"
    end

    cd "dhall-bash" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
