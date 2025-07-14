class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "dd70491daecdd8fe93d85fb0a9c4257d6a71a9f3bc3ed2ecd919b273ca808b92"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ffa80f4abaa3d4feabcc36fe4b755c5ad45967e2ee83b3a06ce4aeb3ec42268"
    sha256 cellar: :any,                 arm64_sonoma:  "279eac5b9d83530fbc55b90bced87691ee6ebf2b3c72cc9af3c19465430d4196"
    sha256 cellar: :any,                 arm64_ventura: "6485993bc52592207a4656c4d4f73f29e2dd943b95ff6f1cf70ee92c72bbb952"
    sha256 cellar: :any,                 sonoma:        "9ee3ff4af18ce549e41dfac1260bad157b2bb8b88eefdd86e51dd6bf494005c9"
    sha256 cellar: :any,                 ventura:       "bcc3351c282ff86c9f201e5d7e4102b1a3c449ff1af52ba9adadfba12ed5d573"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0ec16758aab990fb68ed6668dd18ef92158842c346a291de7c8d4cd5cbe1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40722defa278f2a04e21c0191f21df53355bad43c41f38094a28c45bb5f01245"
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
