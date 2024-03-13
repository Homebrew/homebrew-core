class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.5.0.tar.gz"
  sha256 "9b82fdeb066f88fc818dd27e8a8faa85f83bcefaab5c52272b17fc8adaa1b8ed"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adfbdbc42f9fb5aefd181ea0a798e224a64bb71a46cba200a07a9ae87a744cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64322b9a5298b72c37e6e02a628cb3a0436af0e1c75c0a110776076e549f32c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2ada1409259402345e65638b74d257eeb29a328a854a2b46977c9cfd842415d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d59d317f7d3602c9350d48ee825119e68faeaeb534a7fdc3063c187d3355a5d0"
    sha256 cellar: :any_skip_relocation, ventura:        "0e403eb058cac3f6b40ed45c1c6a7512c1c6a507a231fcfce63e591e225cac02"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9460319891960b3eaf1e6647ab091ebda7af67ca642b7de46c72ac200f0749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff7a7f4adbbb072d382de788b365d1c902b5eef093a7222ff386c89cc6bb296"
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
