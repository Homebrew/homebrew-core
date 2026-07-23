class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.14.tar.gz"
  sha256 "0fcd5c503e471d90ae3debf2238052acf30ab5052bc8bf2deca7e54091385cab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ed7ccd776762896cae329061f28894faa5878c1c4253df6dc70c6d459afb14c"
    sha256 cellar: :any, arm64_sequoia: "6dc62f8cdba9d01bf911b9cee55ee0a3c34d1aa9ff52167459a145a55ed711a8"
    sha256 cellar: :any, arm64_sonoma:  "68869fee25e58c1cc3cb6b3a5204fdadde090c07a8c9667e812753f49880bd75"
    sha256 cellar: :any, sonoma:        "70b2fedede54de683de486cb11fae2651d602cf69399d2b756a98d23320bdfef"
    sha256 cellar: :any, arm64_linux:   "14a37cdeba8a4c6bf0e3b1fa948d2bdfbc04e11bce7f318f99e8a5370a40bd1a"
    sha256 cellar: :any, x86_64_linux:  "96a2e01e1b04b381fd598293afe428585e30ea823ca676500b6dba1ddaba458b"
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
