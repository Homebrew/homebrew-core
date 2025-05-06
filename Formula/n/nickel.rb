class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.11.0.tar.gz"
  sha256 "b80e9bdd3c28644135ba757b0b2d38e63152ef9f045973ea4dd955630d3ed6d3"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3993b5e0839d124ed4f5576a6d8c1aef7a4e5fa2824bf82915c1fe758f56c149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f52b6ce6114559b2f6d0b8fda667756411cc6aa84ef91977b22ae51753db0061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b441b7c58a2a8b98855e07f7a571e60e53a8933d23446ef99107d4918b5a2f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a55d8b72a2cdba23a84607173d908f02cc41efd03da6a217c330994710a8c5a"
    sha256 cellar: :any_skip_relocation, ventura:       "61f0f0e97440c7a9f9a627090f47b998a21ca4cd40242cc727de75a65a9128ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "788a1e37a667b69394949007add28911d146a71ed696967db1a18ddd28f1b4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b50599a34cf55be4723120ff5f829fb6089de57e7b043451f37dc37b733e0b"
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
