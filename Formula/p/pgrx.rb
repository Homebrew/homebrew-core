class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "53358008dd2d63293539440b03099cdf7165f8078f1000ed6ad4ed67064309d4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bac8db8d252561c2fd3035ef3e6b8bf134f53e82c8dd5c3f179a0e074c416f4"
    sha256 cellar: :any,                 arm64_sonoma:  "cefb5693fecbd14d14a76983ea0d7937083cb025cba4129c5b167403cb4a7f7b"
    sha256 cellar: :any,                 arm64_ventura: "8acba827920232047703ce36395b7a13b48bf6c29f7492ea2dbc7922c5b865ed"
    sha256 cellar: :any,                 sonoma:        "51f0ee65d9d4608af7583758a779f8ef82e9fe1499c3e482d0dd6b70d94a9a38"
    sha256 cellar: :any,                 ventura:       "12af6b54d4546d5abfa4c0efe949a4bcb518ec2ada147a1f0725b2a834f9886f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62dcb61755e91671f1a0d6cdd454a2e1f198a252f04e74a4d437924e8ceee8a0"
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
    assert_predicate testpath/"my_extension/my_extension.control", :exist?
  end
end
