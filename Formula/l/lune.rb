class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "4353072ee38d7ded19f487e0bdebb9b631ba7a3d52cb0eabe3be5d98581b16d5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc06977460dbc7aaf20a7ff9e93a1e80a5453912f766d2bf78de38e27217112c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a38c162ad2ac4aa875f04ad8073465e61a946e4db751fc2311ca4936b28ae9be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bae534330ad9cf0df4339f39376863686d066e978d3176aa2ffd26ff495e2615"
    sha256 cellar: :any,                 arm64_linux:       "161a6b481a691246adc53e1820cc46025d09e5e01e7725984cbd513bfaf3629f"
    sha256 cellar: :any,                 x86_64_linux:      "ffe5128e06b2ec68c25a83a5127b6141eba4a773ba2c40206585423496bac076"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
