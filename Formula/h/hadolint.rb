class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "002a411ac608696327d65aaa6e77c8fafe2561429ce56cca0ccb67c2956f8dd5"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "0c196a711ae987baf96f06e2b4dcbd14ce7896f3d2aa56bd59b1a0efcfdc6228"
    sha256 cellar: :any, arm64_sequoia: "cf45bec3ec918058473526ae3f0dc97c13e9f4825578922551ace299027a6b24"
    sha256 cellar: :any, arm64_sonoma:  "98c8d6f39392613e19a40d76fd7e8a6455e4d7de37f1ea8348fcd4f733517ec5"
    sha256 cellar: :any, sonoma:        "22a73cf6466fb6c80f06efbc04a11ee3e7e8325d2f746ee79c01f67bdd4a620d"
    sha256 cellar: :any, arm64_linux:   "718490cb4ecb41031cceb76bea15881ab05a2a4173076901f46dbdb3d5c13bac"
    sha256 cellar: :any, x86_64_linux:  "5c8bd8d3e8a609234d445c5ae6e97e02fbe4b0bf51c401753fc65b0344e631da"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for GHC 9.14 until hadolint allows parallel >= 3.3
    args = ["--allow-newer=base"]

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
