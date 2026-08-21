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
      type :backport
    end
    patch do
      url "https://github.com/Gabriella439/bench/commit/1c4b112436c3eb3e4e9cccaf60525fa4c40fd38e.patch?full_index=1"
      sha256 "df9192a1137883120580c9d1f51a2a742e099c28ad6733eca025bb606a71fdc6"
      type :backport
      resolves "https://github.com/Gabriella439/bench/pull/53"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "d4fa6fb606a05e02d9252adce611cb82c889d9f3043c0f4f5500c688b21cba39"
    sha256 cellar: :any, arm64_sequoia: "23f691588520f5c15826d3d4551fdbb14a71ffea81bf74dc99b50e4c590e7657"
    sha256 cellar: :any, arm64_sonoma:  "2a505e7f027719b2c93c474f7b1180a7562ae41d1063198a00938c1b960a7863"
    sha256 cellar: :any, sonoma:        "9f89aa87f249b9c791f5750a32a038c2849fb6b057035c1bbe8108faf773ecb1"
    sha256 cellar: :any, arm64_linux:   "448885e9f5ff3beccee2f381143cebd6fd251715fd3fbc66c25ad2e0e9f46ff7"
    sha256 cellar: :any, x86_64_linux:  "6964f570f1114a71f8758052e0065989e415f3751b9b846f336490f30953f4cd"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match(/time\s+[0-9.]+/, shell_output("#{bin}/bench pwd"))
  end
end
