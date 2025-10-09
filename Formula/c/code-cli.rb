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
    sha256 cellar: :any,                 arm64_tahoe:   "ca2120670ce3836888d6892439004319604305ca26cc4dbe367829f8392a66f7"
    sha256 cellar: :any,                 arm64_sequoia: "ecb3ac71ed96ec1b8d9fb86e6fe4b953b1f94daebb9ab78f1077ab70794c867e"
    sha256 cellar: :any,                 arm64_sonoma:  "6b097e37d7a992593b9a123d2a7ddf3d8935bdbba1a45c3938b45d4d2c311d74"
    sha256 cellar: :any,                 sonoma:        "df3572a7415123224665174dfb8d7c960b1957d9c083d5ccaca2fae55b961a54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b358fa1427834fdc280e0a5c630c22bc18c04a607aa268a6c9dc63b78d0c920f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dceea0920652c781f3b1a45492e94c5aeb25f22779e64fd6233e29ead06307d"
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
