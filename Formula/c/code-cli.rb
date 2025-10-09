class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.105.0.tar.gz"
  sha256 "9dc975278cb370cb52e66c68cf49b12345efb92e86019264a891eadf74795c43"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bcf3351d64adb42fd124031bc125bbff1cef2326aea44c8c7305c25d744c765"
    sha256 cellar: :any,                 arm64_sequoia: "65eae79dd0899f141bcdb0d85730831cf65c75b4f8d6d701759eeee92775d2ca"
    sha256 cellar: :any,                 arm64_sonoma:  "a4f8bc29c43d845bbdce4f2144a1c50e8e39843e7b98795f7ff62f1affa093dc"
    sha256 cellar: :any,                 sonoma:        "e664b3fe82025c05b9a6c66934df37ec1321bd840268513f8979a847604ebfb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66fed6e159e5e90115d0bf24958c96d9e1d21fbb266030132a19960af5c831c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051f58718cbbda8c4df51bde52907e7a173f79df37358d8916c7b1ff01b8fa26"
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
