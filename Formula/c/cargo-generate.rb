class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.13.tar.gz"
  sha256 "b92c0a9c755b245d519721327d9a476b4a916f752a7662977ea5353225e89df0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4b00ee236a5ee966b63ebd1a011b75a052ad244c583991f5ccb950e06f8f09c7"
    sha256 cellar: :any, arm64_sequoia: "0c3be08974fb19b245ee06967fe3e777a97d59ae345a39d5f92c07285864d72a"
    sha256 cellar: :any, arm64_sonoma:  "0959afe0b4746bf2f88c72cc4483cbdf4dae91cf0645119fa3dcde51ebb5b602"
    sha256 cellar: :any, sonoma:        "600996bc4390ad71d37e129d0500b5289b303bdefadd9b1d727449151d420f22"
    sha256 cellar: :any, arm64_linux:   "e4bfdac2001c37331d757941cbc1e54dbf9118f92fb0e3e33d5fcc816cd786e5"
    sha256 cellar: :any, x86_64_linux:  "553fcf8c319f5edc5794acfdde5be9c34244b9ae33707f846fd3e3512f13617c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
    ]
    linked_libraries << (formula_opt_lib("openssl@3")/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
