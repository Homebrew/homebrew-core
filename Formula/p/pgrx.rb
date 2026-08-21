class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "5d36b7d92f334550ff35a732493889fa746456467187246fff266319b2c55c6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e1a86e6418f1d96b22a6eb1d8424fa358c770a5bdb579f04a63a2ca19aa0fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c662978a596249df2aeb88dc91c06ef648d776013662effb4c2d866be5ad7fee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2cb0d39d3caa07ef1bd9cf9154c3b3dedf14eab54d4a83408fed397c00554f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a740a5bb64ad0d751a7e45aba535d0ff86aa1676ddb735e5bc211c6758fe12d"
    sha256 cellar: :any,                 arm64_linux:   "bd92ad361e993917502d4bed8e3ba4c4ff8b502d871c9975859e1bff7c30f882"
    sha256 cellar: :any,                 x86_64_linux:  "52db2c53486f7e58ac895aa5f55b795011e50e0e54aaec545e434da536edfc35"
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
