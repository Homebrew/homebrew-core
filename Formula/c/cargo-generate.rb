class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.11.tar.gz"
  sha256 "586981962590a77589998cded424e08d22361f63e351c2396c71df1cda5d0a67"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3458b6ddbb7494ba3cf8f9a0ca9f8986050b1de597b14f29a1b140c62806a081"
    sha256 cellar: :any,                 arm64_sequoia: "7df10f3fdf408c2100b1f201559bccb8747366fb9d314efedf68ec517b0fedad"
    sha256 cellar: :any,                 arm64_sonoma:  "9556099ccad77704c21324554fea5dd5bd1562559c3da4177182829692ad6891"
    sha256 cellar: :any,                 sonoma:        "9f903995a217c027a39a0335834fe91ecd7ec8c090e1e26115aa43056d8e8a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7cb79aecf9296dd987d261d11e72dd068f7ec351e55f474d732ae91bbffe254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd21f0517450111a62826ab66d7801f49e09934572726d5b98d2613309862ea"
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
