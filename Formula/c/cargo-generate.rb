class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c12af31c60b7ea53e138e4028a23934873e1385b311f35b46413697bdfdc4e8a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9588d9f3bd24dda034e41947200ee436c009c6b49154fe1a6a57f0926eb539ef"
    sha256 cellar: :any,                 arm64_sonoma:  "e75aae49736fbab569feee8109226f1ec05bc546b3798676dffa1e0c513a076d"
    sha256 cellar: :any,                 arm64_ventura: "deec2fcd437ff10b21a1062f7486dc80dace4af4b26a8a074d917d291e0d5fc2"
    sha256 cellar: :any,                 sonoma:        "ee7ab36f1f870e3d6244e42f351b5fa9e0d4029d75597ccef016f7080c88a78e"
    sha256 cellar: :any,                 ventura:       "78d637fd0809ac44f4741f22c63bdcfdbca7be78e47fcac3ddab1d86b31ac13a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fecca9166bb2c1f7242c43df8dec05883eff4749e8da1edfa88b2bc710c804bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fbe1554f9bd727d311497fe00a1a5f0af0efb3422ada09ad0727bdee3ff2eb"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
