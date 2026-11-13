class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "41b3137dd7e2d9c5bbd9c50fda5c01c7520d7d31690009bb769fbda45abf8a88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "130375a6d620f1931cb69007e47cdb801b7a7dd0a49757f1944d19fb024e04d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68b4b4fca9bcefeb3af6e20c487ae19136ddac9ff25639bb89c73909c3a12ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90f5a610898c1dc946bb0246967592c87ade94390e8203e142793b39d3856d9f"
    sha256 cellar: :any,                 arm64_linux:       "892cec42a606d1c144fa85eed55813c964c1e3475cb35f26a92cabeaa16de39e"
    sha256 cellar: :any,                 x86_64_linux:      "1c7a094faa08c0cd9444343265670754c6520c311b957a038f97da86a4343238"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
