class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.14.0.tar.gz"
  sha256 "7bd9d368f780d506dc63895b7b033ec8b5a98507c7738c2cc263ee5be87cdf67"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cf9dc6aa23a254300d9b423158663da67240789a3467fb662ac010ef43494ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bea2d5279da70984dbc48b60a3b26cd84c9559bfd27d596b6c55c8f928ce44a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ba3e71dbf452522f100acd5dd5368d50721d5058616786c073710b2df20c84"
    sha256 cellar: :any_skip_relocation, sonoma:        "549dd6b6e631555da370868e6b4a4ca73437863e5e6621f751a7649dd70c7844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d064ef1ce5c1a499585bf655bd42ba7103f4562ad1af1db527c1d37e0ba729a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6c85b53534fa307fd1d2840316063c0a1e250d8be14308c20f07f7746a31db"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~NICKEL
      let s = "world" in "Hello, " ++ s
    NICKEL

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
