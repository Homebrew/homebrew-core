class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7c309fbd64ab6510f87346b7d6aaeb18e51b5c766af1dcfa895087dfe5652cd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b46a4876a5217c3a265b3837c85667166b9edaf57a0ca636443371d5688bb0f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b9c37ffb2d49f7a0efd228d9a218debb1b446548847955f049ff046571d225c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b6795022ab3731347c283f0350f0c52a093c6d56627d2552a05f508025854f8"
    sha256 cellar: :any,                 arm64_linux:       "96afbf76650c41cfc17a7aa927b1a4aaf97ca48029e8440f7d42cc78fbc93fd9"
    sha256 cellar: :any,                 x86_64_linux:      "c034102f19d6cec702413df6fcf5ff27961a9b58e648698b946edf506a1a3c42"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
