class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.6.tar.gz"
  sha256 "942f19cd4626e9a439567c23a1cece71fce9715caf52419408709a54cee63281"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1320434b22c5d262d2ee21728eafe1cdb271850aca46605e0fe9be2946316423"
    sha256 cellar: :any,                 arm64_sequoia: "31ff303044c68fde2917b82e2d131e40a40228d77136aea9765df2b57d790385"
    sha256 cellar: :any,                 arm64_sonoma:  "b4030495ec90228b7a9f3a8a1fd03fbb0a1a25697fc238b046ee2c5a0ddf1ed0"
    sha256 cellar: :any,                 sonoma:        "8d9753633464088eca97d26f3ae75a64e3c5f71ff63834cef2a5aa0f5c8319ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91068b365c260a5835d27626117e008bd7a4e2489b904085b07fbbb9c47d1c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854dbc73bf1d37f95ca344f4c21c01383393ef2e6f4e56266eea3af4222efd9f"
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
