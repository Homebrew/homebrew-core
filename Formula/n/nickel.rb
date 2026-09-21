class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/nickel-lang/nickel/archive/refs/tags/1.18.0.tar.gz"
  sha256 "ddcac13684c1fc174a45e0e179ff4ef9433eb08f08bbf4b386dc722cf64ab2d5"
  license "MIT"
  head "https://github.com/nickel-lang/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b652400ef82c68c03fad36128e1bf4f361e2f9006190fdfb9c60ca99af3c85f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50096729e16d9b3a11bf1b4da3493a23f1f63723a7b7004716a55db64d58172c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "989e1583ec8154a4a95987e9cf6ec0d1461f22c89d6b7f77f28b1e33f569dcbb"
    sha256 cellar: :any,                 arm64_linux:       "2461c4e8d4c8d2f64e48012323062509f9a30b4ec5efb733374c90d61f3873a2"
    sha256 cellar: :any,                 x86_64_linux:      "1b8d31421926d564e4646216f7cdff30f5933369d061201e0aa46afcf96f4dae"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
