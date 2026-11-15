class Ghcitty < Formula
  desc "Fast, friendly GHCi"
  homepage "https://github.com/mattlianje/ghcitty"
  url "https://github.com/mattlianje/ghcitty/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2764c26ca4bece4c2d404ad805604029a0ba047d8075d4d13a108fa7e6156623"
  license "Apache-2.0"
  head "https://github.com/mattlianje/ghcitty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cda3696f77434a34734e73997d4a0e80be71db888390b64af0de2a5d8b662d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed0864413a064715f5274cd1f42bf2d96d222a05a1d9e65fd7fc6fc31546bfac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cf74e25ed7dab735b699a5f2123297dc424578aaf80adac2af5d52a7c98a7af"
    sha256 cellar: :any,                 arm64_linux:       "9b02c532a767776162c5bdb7aa5f077463aa7bd92ff3e3b8c93550c9425119d4"
    sha256 cellar: :any,                 x86_64_linux:      "75d289bf6592e79bcc7a6799797653ab8848b00c66db6e86f8611bc78545473b"
  end

  depends_on "rust" => :build
  depends_on "ghc" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghcitty --version")

    assert_match "[1, 4, 9]", shell_output("#{bin}/ghcitty eval \"map (^2) [1, 2, 3]\"")
  end
end
