class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "f8f555332946a19bc029d086a9f6651e3be0a55e6634b62dbfa412e1fe8876a2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe6a73461c94fe83d005e63c608a68bd1a79586d62fe99633c2c0e65b6707e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8194aa5d2b3fea73f486e72d449e8764f0a3c0d6924d6e0a2bb0ba53b122fa80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693c1b4b19e4f240b15c69b4830d93a15621e83f9b78d73c1eefbab1def9a2ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "69cdb8579569022ec60b9b0453cdee895106809ac6d320b437a033bec218b415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60a9afaa9cf9eb17424c2ff0ea79d664c4857dc0955fa251990b8834cde9d912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ef449012c3bd8b7667efaa7eaf878b0df688f2f737d074ae3a12cf867e02da"
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
