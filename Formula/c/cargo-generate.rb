class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.12.tar.gz"
  sha256 "de3aac69feb0085bda238344521c2289e757d2211c5950ab8af8ae826908ad0c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d964462dbd0ad1a4e450d57f9ad12d6686242638b3c25bf42592f5a9cf5832c"
    sha256 cellar: :any, arm64_sequoia: "49d60366d1322794c8094b5781fde746eb2c793a13a0b7e329cfd1526184d109"
    sha256 cellar: :any, arm64_sonoma:  "0168c58898c3b26e540d37db5c1cecce2060993d4fa3490644e886c6e6fa40f4"
    sha256 cellar: :any, sonoma:        "e4e0f2e4fbe99e5d85e4fadf092d328763da19879dba1c9699e945979d10b7ae"
    sha256 cellar: :any, arm64_linux:   "74a74a320439234013b2591f1bdee76d45f3b4a8ef252f4fd5ac9e2809ab8e37"
    sha256 cellar: :any, x86_64_linux:  "ef90d127b3bd3e36aef5ed09e93b33f12aa3d7bb0d090e4b3ed62c5bc33b96a0"
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
