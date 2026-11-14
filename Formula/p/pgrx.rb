class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7c309fbd64ab6510f87346b7d6aaeb18e51b5c766af1dcfa895087dfe5652cd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ca9497d8546531fa0b508a4a7902bfe39cff958f18c86e08d567d961726a02c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cc15e84881e3f1e46fe92dc6e0a05f19278ec68a9abc08bd22b74cac1565ecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3ad471230c24925aeddd4c55e41c8e278937c3d758d0bca5e053301f5c4d4c2"
    sha256 cellar: :any,                 arm64_linux:       "2965e354d29a8dc20ddf850f8d3a3ac62a128034e72c4a8ca926df6da53adc4e"
    sha256 cellar: :any,                 x86_64_linux:      "21acce6ede0317b6496ed3444275f22e3b2c7579323f4b6bbd31620701962e34"
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
