class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.5.0.tar.gz"
  sha256 "9b82fdeb066f88fc818dd27e8a8faa85f83bcefaab5c52272b17fc8adaa1b8ed"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bf99e0582f148bffd0cf403e32259daa13109ce8b646ab431f56a8870d0a505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c11d2f1a2836ce659776a7e907927856591a8929b42160c169c6e140077770c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13e2bfd279f8dfa3445cd30130d9a5954d3c0249e41c2e1d1f3a5f77adc07ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "65ddda7a5e3887360890408a34cfe0f7ad7c169e1f30457bb369a7436c41e534"
    sha256 cellar: :any_skip_relocation, ventura:        "b2671fad25bf330bca64a3bc7881c4c07ee6314ad8a5a5eb891427f4cdf8defb"
    sha256 cellar: :any_skip_relocation, monterey:       "88366b57a4b608dd9af590f7e225a7c6627750674f7b3814cbf380cb3f19e0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c7c27daa61c1b2339b98ca3fa0b34a86af90773a0550d6803fb31c1aaed634"
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
