class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d45ff33c8ed1e3a589e1a80c3758ea5269fb5932af215074b0027a90d05b7b25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f62cff0ae1fef317e96fa1349e5472988b4dcf0114efa85c9b443304037150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65399a128a77abe4f74c5ca1c336e3e1700e454733fc569b8eb1f2a9079a51d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73a2118ddcef674fdc61d43dca4dc84e65e170287be808f930f2e7bb8626eee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c220d9c680160a1f98c6df48287077ce659e6834d6ab7edb78fa584843cc22"
    sha256 cellar: :any_skip_relocation, ventura:       "914072831d8998bf4592e4fbda9a4244b05762011c9f653a857c4e325345ae62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a6557f307cb41da8d3316fbbed4e67f5b761cbdddde79761c330b5caa285af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f7712bc60d1adc438b7c47f7240df6df91b74065020e8ba8857de46f870f1e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
