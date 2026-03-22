class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.7.tar.gz"
  sha256 "7f6dceb0ede61122684d4852092331c7179a5ea236247688e5074be68c1d9e4d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34791473078f76879f23bfa46b602f9bc861fdd9dd33bb2af4f3672ba5d0ca3f"
    sha256 cellar: :any,                 arm64_sequoia: "7715d55f9ce8322e500573d731a09560242cc008d79fd9915037271c270bb923"
    sha256 cellar: :any,                 arm64_sonoma:  "64aad8d85e1a3ef8d26fb88f1325cf1d795efe4a4c6db43009af4af5b289260f"
    sha256 cellar: :any,                 sonoma:        "96eeba249472831404dd4a494e368ec236301647294a993d02ea5f51aa91e369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3897578d246b7f1fbff2f9594a6f7f2832086dc0a26575d7dd2ef8ce7b4f5329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd95c9ae28e6dd897a42f4dce961cc4589e25d78034b2363b5a21c8422b6531"
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
