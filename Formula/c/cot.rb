class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.8.0.tar.gz"
  sha256 "89530ac4e9b49df21679b55f9d7fb392bbc9b167da9707fbd6862365f85c009b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b70f92f3b2443222d07c433fd74e1e52632eae59248c1c0a86fd079a8f71fbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e6ff6083caf34cb7f4c5a2223d901ed8f7728ec7e9e2eb9292db66b153da068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5875227a4e5b95c54b81a5478b0b01500466644044b5257fc07e5a78e035b88a"
    sha256 cellar: :any,                 arm64_linux:       "83477338b2b6f724a135341b2cfb05fc2df241079fba2f455a13e693b0a3307d"
    sha256 cellar: :any,                 x86_64_linux:      "530af6518f69d8537afab58b82ca9f91105ff92b69e10ae3edbf98d44a0ab80f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cot --version")

    system bin/"cot", "new", "test-project"
    assert_path_exists testpath/"test-project/Cargo.toml"
  end
end
