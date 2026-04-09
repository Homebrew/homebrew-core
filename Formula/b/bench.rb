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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3064182e52b625f6abe652df7f1d6d7a01f2c58ac27bd8c7561bd03b9ca7cb80"
    sha256 cellar: :any,                 arm64_sequoia: "a0386f704c608217e565de8f96d4896f24442fb9b9c4ab7d6eca35e2207b6faf"
    sha256 cellar: :any,                 arm64_sonoma:  "4c385be74bcb734fdebba6911e0c50f03372589fdc35a3cf30b4cfdbd24c67ff"
    sha256 cellar: :any,                 sonoma:        "e1fad9d66bd1904f7c6ce6f084d36719727b3958a456b8e00496d60e90e5a484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b44a07113c5f89b4e662c0e25e233b5a5c50363dc329ac76d1adcd3246967e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bfc8a2a84dd8d843c3b68bbd054aa1493353210d1657062c5cecc5de9f4d982"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match(/time\s+[0-9.]+/, shell_output("#{bin}/bench pwd"))
  end
end
