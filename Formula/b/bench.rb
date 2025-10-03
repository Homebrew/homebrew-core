class Bench < Formula
  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriella439/bench"
  license "BSD-3-Clause"
  head "https://github.com/Gabriella439/bench.git", branch: "main"

  stable do
    url "https://hackage.haskell.org/package/bench-1.0.13/bench-1.0.13.tar.gz"
    sha256 "170c396f59e37851ed626c07756dc394841f7597895e691bf26049fee9725a6c"

    # Backport relaxed upper bound on text to build with GHC 9.10
    patch do
      url "https://github.com/Gabriella439/bench/commit/f7efa5225eda160ca1cf978dc0147db4e1902e3c.patch?full_index=1"
      sha256 "dc9895f4421274daa4e1aca04150b9e07eb48dbe5c11c1894aa9060081260342"
    end
    patch do
      url "https://github.com/Gabriella439/bench/commit/1c4b112436c3eb3e4e9cccaf60525fa4c40fd38e.patch?full_index=1"
      sha256 "df9192a1137883120580c9d1f51a2a742e099c28ad6733eca025bb606a71fdc6"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0ef5a04cf943fb775dec58c9f01e7a351234e96415eeddf7a1334fdc25e44125"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9c5230fa0e73d5d95d308cba623b7482ecb7615ea7cba70da81cc2eaa402d911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e53da698afa731c749f40351c628f1883c1e02b9a1d88d7d77184ed938b4004a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95efaec2d62c71aa134fa3ce9219acfe3cad30adcd4dd39a677869dd577ddcb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58f3eaed9c9d200b98ae8cf639d50270d55353eac3cf7630c5ec256e18ee179d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3bb09eecf4d8c6a6be9de614227f20d1745abbb11d6de6e55d627ab82e381a7"
    sha256 cellar: :any_skip_relocation, ventura:        "dc156d8b5153328baa9611a2b3debce3ba9579ce5de607843f7cb1446499e3f7"
    sha256 cellar: :any_skip_relocation, monterey:       "0b40ea1f0980aa3d99c04d339739a8a9db6f149122e327b5b6f8107f972d597c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9524c8585e0d39098a57f013cbd52142c7bc67c409bffded1f3fc9198c3e218f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9558853d72f47d9f9ebec85e2e80eef181c37e607c7e40cf398845e49cf576"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match(/time\s+[0-9.]+/, shell_output("#{bin}/bench pwd"))
  end
end
