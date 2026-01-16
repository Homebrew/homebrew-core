class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.107.1.tar.gz"
  sha256 "695707e9a46ce79fc03faece47db443ff940df0e59c5094562a0b9e0610caea2"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f82d1150524244e70ed69039b20dd91d012092dcd33003e9bc0018d5c52f1c37"
    sha256 cellar: :any,                 arm64_sequoia: "bbd000e3b9ccaa7f964a7c08b04d0395f9e2f2e2ee4b225c8439529bbad9de37"
    sha256 cellar: :any,                 arm64_sonoma:  "5a4079e45fad1350180c6ea6ed091f30a3c04bafe03cb5dbac745904aa4ad435"
    sha256 cellar: :any,                 sonoma:        "3ba11d52e5010e3ca9daaa46716355ac1b1159055931871c87ef36ab8296ecf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66e07843828e633e9ee82f9a76ddb58fcbd08b8e1e1fd39a22a6ef38ebd79427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea039df5125d16a7640615ed3a80be00724050efef72ead4866dc5e0ac5b1b1d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
