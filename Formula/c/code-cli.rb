class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.104.1.tar.gz"
  sha256 "f2d420ad44f5fef84cb24505f47f22d16847b509fbd2b6cd22bf58c2d0df4f4d"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44ed95162a38a26b56ef91160a16002605acecccb6096dd7071b91b0a6822fce"
    sha256 cellar: :any,                 arm64_sequoia: "7dc126aff943f161a32df6416f23ca8716471f9c0fdd8964cff75f6a355fe813"
    sha256 cellar: :any,                 arm64_sonoma:  "c79f5df0b8e4eba97fa5e774f7629d015d02539ca2efc6cfa4eb116944650c02"
    sha256 cellar: :any,                 sonoma:        "c6306ee48fa09660cc8ae7af8f92ed1b0f3d233f5bb3e910d17c90c1b604e6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6102beae70726449bfd02ca834893b535b74fa83c9065757e3ae1c61ec9d1777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207422d1b92999ba3186ec86de96d4f99f92155b8074a0450dd071a3347f5741"
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
