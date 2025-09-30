class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "59ddb9f0715e3e0ec8190e1c158f5cd013a2d19d855d4946970ea40d47b60570"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0e4fd2ea3329c2746c7bc58b2c726bba93f05fabcc1aadb8a969cc370a5d42f"
    sha256 cellar: :any,                 arm64_sequoia: "f68d984520cf08961e05406b99ac47babc34a4af29d8373cdf805a8d9aa15d8f"
    sha256 cellar: :any,                 arm64_sonoma:  "3e3d1dfd2e07f1e098ba5b088a028c15d6fe556af0c4d6c8fb0fe021c9f8a568"
    sha256 cellar: :any,                 arm64_ventura: "2d52c1abed1cb03a8cf02eda228369e9f36fb70336d00db303bb2dd0b9d439f8"
    sha256 cellar: :any,                 sonoma:        "72008bfba612207a661570dc08d8ebccad9191f3e12f40fab26480c4272c69b5"
    sha256 cellar: :any,                 ventura:       "650b05e8dcaf802e5feda6b4f46e036ccc875129c0c088a8e0afbdd1943bb1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5372b43ee3e6d61d400774d926cd192c928014eb4bb56e213c74e858200c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0f024bb1eba7c418b21690dc2703a88cc57645c8c59b2eee67cddc280a9bae"
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
