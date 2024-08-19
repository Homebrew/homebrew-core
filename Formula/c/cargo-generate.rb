class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "91b89109da5911e5964e5581ab584c713cc0e9b96ef1eb58bb5fe3f7b853b9df"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a84fb4e9851860da41e3eb82d83d07860eebcc926182b1ab5cf2836986e2801c"
    sha256 cellar: :any,                 arm64_ventura:  "f3b3082fc6b9faf1b4630915e02d3020e8a54e40bf1addecb124927d539e4d9f"
    sha256 cellar: :any,                 arm64_monterey: "4511fa176fd18d7dada3ea3d54acf0673f89230885864c7a320e7aa011b4f08e"
    sha256 cellar: :any,                 sonoma:         "01108e4f3b94f140cd224f9c9f9050460e86492b8543e89c5ea3fc1e57a43322"
    sha256 cellar: :any,                 ventura:        "cdcacaaf97e9186cb7b9ef6143bc79b114fdc91ef13867c573c66edc2b2a9595"
    sha256 cellar: :any,                 monterey:       "82ba8af462f1f259a2e38ea3a9b79f21456311f55e77bc4ca5a7e7fb8153024b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7eee9eba19b6e9a335884bce5ad37e7d30aaeb356065bda6e92c0a7a04a40b"
  end

  depends_on "pkg-config" => :build
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
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
