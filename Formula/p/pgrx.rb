class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "65243eb07e2979db3f4536e353accec1037bb33d5485669afb2f652ffc4f550f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd5b2d8f08d7d6ecb120e789ab2c9dd61082bb1be08617d4c8efceaeb82e64f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab3f075c46646063a259cef20b00c579514f60f4974bf09a8915e43348541f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eba6c0b8b346ce032c32e4b3be1ec6310b10cb9d70a0ebb61c4537bade5a0fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d6f3f683b189fede332739d6d65e7337c49ea4469c83274331155bdb4b6ea19"
    sha256 cellar: :any_skip_relocation, ventura:       "ece4fc9c89237b468784170068f1a3e476c9c2536c3850b0a9d471490109d526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6eb1275c721e9d6ebad7601ed3857183009988a1d4ce11803bdd754a9d8c110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fae180ab458941618f2afc02b206b277f4cae2830218cd6c7701addffd14b3a"
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
