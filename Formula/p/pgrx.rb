class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "fc39703527b34f916fef9fb0e44e8aab3f5691e1f15f7e89030d96050c322afe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93ef1e628ad8ca6a9eb7174dbc949d2465b9324f92a979a7bf1dab2f4c5cab29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13d89e91363f12e5a3d0a8c2c6f1cf2a0836922cb016c74cadab02e1d1fcd9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380c2dabb4cc76115966d4cbe542d088646892e8b486e7538d0019e4376e63de"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4ad7d75687f82d59862f5b9d75d01333cf51492975da6118bba10f4388a502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7557d8fc1b6fd4968c12a88942419ae526085f454b409b793b471c2ee9842f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58aac8c85d6f4a68f7c3e1891ea59703d2481590cd0603194368968470281196"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
