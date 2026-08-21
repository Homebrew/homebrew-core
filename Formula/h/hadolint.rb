class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://hackage.haskell.org/package/hadolint-2.15.1/hadolint-2.15.1.tar.gz"
  sha256 "53a210184be82bd273fb298c0887a84e7d6c1d08fcdfc376373235c0c786bb27"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3b56bd5bd4962f8a11044ebb2390b47461cc9765f7b5e92ad62b659f610775dd"
    sha256 cellar: :any, arm64_sequoia: "2c0d588da3ac20ef9345530a5d7b2aa686eb70366003b63b711e63ea88386938"
    sha256 cellar: :any, arm64_sonoma:  "2de6097337f7d48284171c12a894ae1d8d8e3da4c282dbf6af9951dd76c6fdd0"
    sha256 cellar: :any, sonoma:        "5a5d793e42cbca60bda0ffa7fbcee10e343c57b676ba76665cc1ace7b5e093e7"
    sha256 cellar: :any, arm64_linux:   "a6f89c0126308b57ec5938a283c19452e30fd45c3f55aaca10571acc9b7be61f"
    sha256 cellar: :any, x86_64_linux:  "6a9e2ad0f9989876218cd38738b1350105fb1a35fc74495647521f5331fe82e5"
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
    args = ["--allow-newer=base,time"]

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
