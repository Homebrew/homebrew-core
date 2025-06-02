class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "af5e0026d9e734d1412f5dcf3be196b6b51f952867b6eb361f49df6d55fccf5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd02c5e460fd47f8fb36dc2966c0eecf4a4e3e9faf6e713df5c2a067edf61045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d0a1b58df6c06550e38892f3f25ab51b34b3be375251dde286f61e41d359f12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f8bf7e100e277219b0a01eb10ebe9681e566067aebecef165335882184c7017"
    sha256 cellar: :any_skip_relocation, sonoma:        "de59c11d9ba2a511e83181330416cb1ad54ec0e8aea2d88220846e6059385766"
    sha256 cellar: :any_skip_relocation, ventura:       "59078b5be62dbe49c6778ce12d87b13c803803848ce250da6d142ee455d784c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1320cf98cf58207fde64dd91bfdb6c3db3f882058b19825788a5f77bea3aa2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9df726b9148c6593f1e4b3beaf78903a99d41cd999e11f6464d634246b7c25e"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
