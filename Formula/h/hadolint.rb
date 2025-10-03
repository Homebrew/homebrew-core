class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "002a411ac608696327d65aaa6e77c8fafe2561429ce56cca0ccb67c2956f8dd5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "625b9db801f4540117e0a36ba75d80daf0f5a62a0e7efc567fcb2e45dd2809e8"
    sha256 cellar: :any,                 arm64_sequoia: "8f921836ab7439f49d938a06dfe2cd74f08f4071343668488245f72b970b0ffd"
    sha256 cellar: :any,                 arm64_sonoma:  "d6e9f305fd34de4b4cba2ec91aa69e4bd90ce588da7714e82cfa60f102a74e02"
    sha256 cellar: :any,                 sonoma:        "2d04e42e392a9157bb74bf3e8e930e4d6bad68a5876f0a3b16641392604fe179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a9c84e75a91304c5eb1aa234a507ee78f651f88d48d23f96ea9a162eb1bd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3ba3e8be4d79224cfe1a24d75008c89d56193d884e20d053b1e1079d016f0a5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    # Workaround for GHC 9.12 until https://github.com/phadej/puresat/pull/7
    # and base is updated in https://github.com/phadej/spdx
    args = ["--allow-newer=puresat:base,spdx:base"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~DOCKERFILE
      FROM debian
    DOCKERFILE
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
