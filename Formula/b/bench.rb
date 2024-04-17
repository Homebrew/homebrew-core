class Bench < Formula
  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriella439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.13/bench-1.0.13.tar.gz"
  sha256 "170c396f59e37851ed626c07756dc394841f7597895e691bf26049fee9725a6c"
  license "BSD-3-Clause"
  head "https://github.com/Gabriella439/bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e53da698afa731c749f40351c628f1883c1e02b9a1d88d7d77184ed938b4004a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95efaec2d62c71aa134fa3ce9219acfe3cad30adcd4dd39a677869dd577ddcb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58f3eaed9c9d200b98ae8cf639d50270d55353eac3cf7630c5ec256e18ee179d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3bb09eecf4d8c6a6be9de614227f20d1745abbb11d6de6e55d627ab82e381a7"
    sha256 cellar: :any_skip_relocation, ventura:        "dc156d8b5153328baa9611a2b3debce3ba9579ce5de607843f7cb1446499e3f7"
    sha256 cellar: :any_skip_relocation, monterey:       "0b40ea1f0980aa3d99c04d339739a8a9db6f149122e327b5b6f8107f972d597c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9558853d72f47d9f9ebec85e2e80eef181c37e607c7e40cf398845e49cf576"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match(/time\s+[0-9.]+/, shell_output("#{bin}/bench pwd"))
  end
end
