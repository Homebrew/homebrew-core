class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.8.tar.gz"
  sha256 "52455036c3ec98567de0d2529621b93d5811de48e67c2e0a25798578f85ad3f7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01f08ea11d7c5127a6b745f2852c2107ae88f9ea122491dea7f9189c1f0c5bb1"
    sha256 cellar: :any,                 arm64_sequoia: "c9f67573672dae847b4d8e89aee742504320ac3ff8c9c5000f0509b2416964eb"
    sha256 cellar: :any,                 arm64_sonoma:  "439e4a5d2a705ae907f5d11623b20846c64eda813c8ab66037581203d810131f"
    sha256 cellar: :any,                 sonoma:        "273a63c51e32bf38bdfb6af61dfb53924fd7e8b55bd1f0f2522c03317a7e76d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ab3b97088e8e29508ee9bde36efa65ea5195fa9da91b2c0c629309fe049db54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13cfc93d4845b502cfa9c4f87bbe254b602a81ce2ec4c6086dcc897849c1f1f0"
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
