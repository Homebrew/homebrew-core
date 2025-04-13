class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.99.2.tar.gz"
  sha256 "e984a4a099425790a26bce5c26d2877d62ec623175af481c013be08217fef533"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf99adb2d1bc9b53768f49de708945486e1e24e4a5d643e605445de731e1fd83"
    sha256 cellar: :any,                 arm64_sonoma:  "82d5420eef276e4016fb381327ebb4e50d566362087f3b2b1672548b8c32b997"
    sha256 cellar: :any,                 arm64_ventura: "7a7840c9ac1cc43c1c9c979f22dae45952ad9abfe490dc3d8934268300fb090d"
    sha256 cellar: :any,                 sonoma:        "d016efca717126694d48919bb3e502aede9e87cf3f347153e5a65eb0a44aba82"
    sha256 cellar: :any,                 ventura:       "3ece8aad05f3bfd92eed592f8b2554920661e421e5a8d340864729b736fee1a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5808482e46d9cc121cb6ae875d526498765b5f223bd0c78f5652d4e916347b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d7b8bcab76ab2694473285e59541ca1845fdd8819cacbce8244160931c63db"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
