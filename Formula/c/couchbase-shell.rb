class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  stable do
    url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v0.75.2.tar.gz"
    sha256 "72d99bf1de8a050137b080825299eca01d2aa4fb5e10bf75927008314e88b783"

    # Use `llvm@15` to work around build failure with LLVM Clang 16 (Apple Clang 15)
    # described in https://github.com/rust-lang/rust-bindgen/issues/2312.
    # TODO: Remove in the next release
    depends_on "llvm@15" => :build if DevelopmentTools.clang_build_version >= 1500
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b370cd8dbc1c5df81496309a679c713820cbbf34806b7ea56ac17174edb52b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "311bd08f0e1124ec4bcb6b10c4b0837cc153678ed436e7d1c876ea447c5ddd0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "332d09a84990ce0176557353b842d7ecdcfb3279b90eee9f6742be3c87eaa910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de39e28bff9b2e2d1cb5c2b54e10ee4bb1646fa19ea0ab3feef5729ba1ea7bfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4a61feed429597d57de9fb262c077cd133293c3fffe9deb44f66c2a2ef45168"
    sha256 cellar: :any_skip_relocation, ventura:        "65515ea14fee716e8b7b6bd3c1afae1cefdff348b493a985ebdcc81c86c81f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0ef9f1d4803f103ad256a3b8248867a9d3b25294bda98434b84229a1f78419"
    sha256 cellar: :any_skip_relocation, big_sur:        "81798858544b739e736244e94098131f6e7d2c5ad3dedcff91aa641e0bd875f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea805526c8d9cf548f9771302c502c5e3c809a2f09063d80e278e091170ac7a7"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    odie "Check if `llvm@15` dependency can be removed!" if build.stable? && version > "0.75.2"
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "homebrew_test", shell_output("#{bin}/cbsh -c '{ foo: 1, bar: homebrew_test} | get bar'")
  end
end
