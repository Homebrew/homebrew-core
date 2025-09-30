class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.104.2.tar.gz"
  sha256 "39691f236a219e71195abbc38a6239a99f8ebe5abea1ccb0357b800ad8b58cca"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f19580f8776f67ec8de90560e25e9883f548a8951dfaee44f7cac07d9733d692"
    sha256 cellar: :any,                 arm64_sequoia: "843ffba9349fb9cfd1f590caa633ecfa6c898557db44a39a0cef34e8763378bb"
    sha256 cellar: :any,                 arm64_sonoma:  "19fb09a6e71bd9944a40e8bfd9bd6f7d37b548149944d2a20894376922872319"
    sha256 cellar: :any,                 sonoma:        "6b405bcf9a7e9881c291d75685da80508f0f5eb1b3af365ecfd7a8b60f2ed591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd800035e9e4c15196ca10e06deeb74d57a3abcb38f2fc6a78158c33693ed834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398114a36d9a28d618d6b78b44628f4edfa7f5f8ecda4fa34cb80be933e5cb16"
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
