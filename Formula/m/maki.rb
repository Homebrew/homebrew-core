class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://github.com/tontinton/maki/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "c248243dada4c76217bc62142609faa94fc329afdd30f04966d31f2d24d01bb8"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98d56ac449f3b70810e4f59299c3740fba88335425c86d3c8381499753bc8a24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee9ce8944e88e7f48350f85e15a87a2fc0f86443eb00ed0de4584ac236a00059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c055c6c9f62855c8a3143636d3329e6a0ae66e1209592056398f124a2b358320"
    sha256 cellar: :any,                 arm64_linux:       "b58fc2221740a108b4bac516c72fa2909511918577b973a48167e2ad94f087a2"
    sha256 cellar: :any,                 x86_64_linux:      "3c5c81d0e44ff0604b12e63ee6e4122ccfb16a61fb2a1b14097774e312025093"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maki --version")

    (testpath/"test.rs").write <<~RUST
      fn greet(name: &str) -> String {
          format!("hi {name}")
      }
    RUST
    assert_match "greet(name: &str) -> String [1-3]", shell_output("#{bin}/maki index test.rs")
  end
end
