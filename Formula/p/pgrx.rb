class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "08cf0bf97f25dfd6b4a0fdfddf0d105bbf0890960c2de30eae31c8ca7a0018e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69e467aa093ee63b83807a333971e8e665a29494cc94a779c4ac1072377d4ea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3439165334df193ea44c6b66acfdccf026f365984d4afae68cbc6e14525ed000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1cbc7f54cefc4cf57c4830283690dbac4813c38fa687b0835ad60d30c11e0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98b1cc91445d6b71487ae0cd9f3a9bc47ae13c0134175475eb8ab951a4eb3216"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa8b8f5c1178938d183404d1a81f9866ba7dc38ba7271f22d6f8dc7978c5812d"
    sha256 cellar: :any_skip_relocation, ventura:       "6a174a0a1cb10b6fa376a99548e669c7c6d86fbbd9141002820a93683f7a056f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37e3ee76e132856f52ffc4ad712068fbeabd8e24886b484eb67a970e823511d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa6efb15760ed93b6b773846dc58764f30960ff1172fdb05aaac90bfdec7be2a"
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
