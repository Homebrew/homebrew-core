class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.6.0.tar.gz"
  sha256 "191d2ee9e1ed02600795dbe220906d528edd52c797bbdfcda17d06c53686042f"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58977d4e1db3ff658cf6887a091a7758426bbfdfc323b81b28e58b799c31ec8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c44570b4419710e5e0c4ed8929c1a2db1d5ccab57dc0b854a3fc6582746dec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "257cc67ccac97a448b743b2480821fd84c655ad7d6567a900d7cde67dbc3528d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9d6eb305e6c5cabab9d815f22eaf10e47a306487b25d47f4482c720c30a021b"
    sha256 cellar: :any_skip_relocation, ventura:        "0a77e27fcf60a9749e8b8c4a1a3db37ae366bbd15e052e2b984d4c6d4eac4237"
    sha256 cellar: :any_skip_relocation, monterey:       "11ddb718731cb912339002d07a3ff95d75dc1899d7ab5879f64a8cf022b90338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0cedb8516786ab66ddf1a1b012688a85a25618763ec6e5501ee5555895e0bb8"
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
