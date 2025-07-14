class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "56df0ac710d405cf5cd0eb5323c3e5aa3fbad21790c89489b6a165156b4bc149"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f2c50d5570f451038259800b05950d742a1a6533b2aef9034ff7fd375982ace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "035466530f2602de6007796a208969e5965eeb08ea25dda724c4679b8efae359"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19728769518bbe1076f357829ccff126bfe611bff45e761fd6becd80a53b62ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb2cf896e76f7acd252ba16b7b755e59b81264e92c5d9ca40a3edd30556ca06d"
    sha256 cellar: :any_skip_relocation, ventura:       "399b1a9e40ad38e9c91d1ef15f0acbc86f780dd42524e438aa94a5485c2ffda7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eeced03f6c07f86be460e1ee1093dae326f5d81d855d6db13dae0bdd2c87c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b9f2c624f60093fba7942436ee21104d1816996139bdb08632c31f9c0e5852"
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
