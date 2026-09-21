class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.138.0.tar.gz"
  sha256 "d7875d5d325dffb672903281a2a1961be525819e6a712b94b921826747b698e0"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dbbde316174759a9005ab66520e7cf6f71ab612afd5379ece4b9c8b5d6ab6d98"
    sha256 cellar: :any, arm64_tahoe:       "9ebcffdcd69e16ed2a7adcd2c2703c5b4dc39d203829d6e69750eeda4640bb7e"
    sha256 cellar: :any, arm64_sequoia:     "31ecc1b81aedcfbe9b232bf2d47cfc2ff365f656c2b1878ea0fe26c194144cd0"
    sha256 cellar: :any, arm64_linux:       "9e71ba4d9dd56954fd23d8d19fe3e647ddf1f009ea71bb0c01be697fa734e890"
    sha256 cellar: :any, x86_64_linux:      "3f454c57384f9fb9cfc9f6234c4a65014e18448d22afe60d2c16fd9ab3117a86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
