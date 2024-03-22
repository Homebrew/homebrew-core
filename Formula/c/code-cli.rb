class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.87.2.tar.gz"
  sha256 "31dd6b75c60178d855c61bb1f4c5ea60949323ca28ee5980dfe4905c22bb2e02"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab30f53179ae66ff792c3ef94ca2b9477d442f2b73d0846e19bf7b5773fbc05b"
    sha256 cellar: :any,                 arm64_ventura:  "1756df9f6cf07ef4d15a6703845c0aa370114b3357ab88ed00f88246a9f578f9"
    sha256 cellar: :any,                 arm64_monterey: "5c7fd0b4be6f4d22a1b6a60cefbd8c4e37cc81b54f37239a7c7b87ee500aad16"
    sha256 cellar: :any,                 sonoma:         "f0bd14520c8d0931b58689a39de9e0e0758f47d854f6f4b9d02218d87a679f4e"
    sha256 cellar: :any,                 ventura:        "a246f9032ad5d66962daed7115810806cabcba7e21fe3eb6425a1538e926358b"
    sha256 cellar: :any,                 monterey:       "a8f7d5e26c7341ff8b094a150371374608bcff75d1e7a57dc8cbfde92b28a990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f350bbf9e17d469b706c659ac341827dfb958c89280be253a1842d7d40eea9db"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
