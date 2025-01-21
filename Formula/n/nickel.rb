class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.9.1.tar.gz"
  sha256 "a775ef5ec0f375fa75f9fbe146f4b5c9bbf8728b39ac73fd0685f32b956e5c99"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b3018dddbf9ee4325c87dcd80c63d235ebd926b510a9ba00b87f21687e9b642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c948c81c8fd52ece904ec2d0bcae6eaeb76a65cb9213e29f3dfa30981a75006c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdc8153cdcdd4b774936cb1403d79fa15aa5583bc0b89d872ba4bb166bbd2226"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c79daf6b1803fbd529494cbaa1a00bc408a7e99f94b25cd39a4d3d5c7c09e02"
    sha256 cellar: :any_skip_relocation, ventura:       "6a935c5b8d59fb364f31ca1d289b9270438c07813d9d141482e4363d7bb0fb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f135058679495b488b28d749b821fc63b1a283b17c8ab14b92a70f375c09f2d"
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
