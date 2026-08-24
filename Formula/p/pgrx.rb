class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "5d36b7d92f334550ff35a732493889fa746456467187246fff266319b2c55c6d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "556061ef9dc90c485cff3092c87a6f18227773d8c931f8af65157de9bf7f9fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ce76447bad80ab2b95034d4c643aedf62060e7ed1585da66735ef2aa6655bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6298246d4dab3424d595b109882d3888e9ceb5a7191fdc7ddfa039c81cef1779"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa1193484a327f86a023ef96589404ca032ba9651c8f3c3440a317845c2821be"
    sha256 cellar: :any,                 arm64_linux:   "f3c115806a6b6af5268ddf015a3a019db5651778cd597f05076971871c436ddd"
    sha256 cellar: :any,                 x86_64_linux:  "4729d9b62af60df34b07340e95bfb2e34490afda45a1aeac850ff4e2e6ea34ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "openssl@4"
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
