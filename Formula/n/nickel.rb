class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.7.0.tar.gz"
  sha256 "0a187cb5e4d34fb485ae7ceca77e18b27f22860cf79c03f92e12fc5c2c59c01e"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a522d3e1aae94df5f30388505f28acc4eb6bc3c3fc959a530ebb552d5dc0d951"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6881c9772da598c5e5d26b8d498b12202f7ac6a086b2ba9debe4fbf092f304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e4b08a784947748e47468eee77825a5f0f5cc43d115318170e6c73b4d86622"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc071ca43f33e73af100f18be725773b5f2dd2dc4aa4b9371ca09cb981123328"
    sha256 cellar: :any_skip_relocation, ventura:        "2dc84f6726c6eb472401f06e8daebf90884f8f3326020b59c2a1f48b8859234f"
    sha256 cellar: :any_skip_relocation, monterey:       "8621559b7921ad62b79ffced1e3c35349b202409e917e65440668bdbc6c2cac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c615d3fdd6ba13c24c61632bfefecb555d9f1e1103f0c4e6f28784e007e21b"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~EOS
      let s = "world" in "Hello, " ++ s
    EOS

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
