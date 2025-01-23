class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "f912f1c172a5a51ac7a693f44acaef99f5b9278723aa4daaeb96278807e025bd"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc8c8913389620fe33dac4be8b56cadb0706a12868f3010f59a3ed10205428e7"
    sha256 cellar: :any,                 arm64_sonoma:  "de2a3a85b67415125afaae67fdee814e6fd72fbca91ec89a018ed7afb010dad5"
    sha256 cellar: :any,                 arm64_ventura: "453fdc9e96ba47c20735ede9c836825d72f87376dc7b8c97ca4a0b217297cd31"
    sha256 cellar: :any,                 sonoma:        "6525b1e29c5fd2ba0c5c8e99940d6f4114888658c25312805d7ac61a8551cba1"
    sha256 cellar: :any,                 ventura:       "1e4563b9ecc0817e6bd3b86614f5dd918f78817a626e45d8441286a033dd640b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad35d30247d8cd9e9209b5c4a6d36f01018d531eb4e3d9b75912012c975d672d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
