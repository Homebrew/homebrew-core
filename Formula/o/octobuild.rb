class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/2.0.0.tar.gz"
  sha256 "ff6c54184351fb03e1997c59db98eec705a5cea2969d72d220f50110d4c34853"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "795fa73f3a6b09f2d31291259713b08c65a1fb344946a9ebe08fe8adc6692b7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "774070041d50dfd51c7187e8af49ac255094d0bc5f8a429390e634e7276ca54a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcead0bf62c999991c870bf8c0f4b5fdf8dc1125c4eef7723c47344a4bd37a65"
    sha256 cellar: :any,                 arm64_linux:       "3f689aa09c5d00a20255c293eae7504ae204dcd3be27941096962244e66c3dc4"
    sha256 cellar: :any,                 x86_64_linux:      "df99225d6e9d5ce8bf1eb23cf05c7f673ec59c0f91e66d934c01661983705fdc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    # `Cargo.lock` file is ignored
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
