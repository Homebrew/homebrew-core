class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "a2a4ec1c90a17fe31a646cc2bd505992c28c375ba8a798d5cdeee27ca5d5ef0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b681c42f6fcc16861e610db5b3668904cd5351d490e30e3679e837eee9f6db1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cae13c78789a51d8937868531698ccf680fc5056f267939e1a1f72bb7c96bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96136a62114e5d8d78f9922fd2464a06a5a8beb49320192af82aa5f90f3834b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "701de1691023c4228f28e154bffc4b9062c204d614352a2057337c8c8af5d25c"
    sha256 cellar: :any,                 arm64_linux:   "a79226b07522827f51bdc06376d8e712e6c08e920894484a445d5ffaea334075"
    sha256 cellar: :any,                 x86_64_linux:  "6464ed21f015d69b01c82809010b05462d8155d35e5a9ef443d1d3bcd18421d9"
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
