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
    sha256 cellar: :any,                 arm64_sonoma:   "b0812b95380129485011240fa5a73507f4a4d4caeb239de984176b8a1999fea4"
    sha256 cellar: :any,                 arm64_ventura:  "6867dcf93afed23aa6f1f958575526c1f2ab787844934af450f6317bd13f3d1b"
    sha256 cellar: :any,                 arm64_monterey: "bb2d9f818460064a901bf159b800ff4a1bf5fef026d93b1344a18ad721bda32b"
    sha256 cellar: :any,                 sonoma:         "81d3d2e42c5b4f282deb834ca30d66418f4cb55a369fa3fa85e439a058ae25b1"
    sha256 cellar: :any,                 ventura:        "16bfe03071cd64c572fd3ed3e43ab5082339feec48b1574b99a505933ac75b2a"
    sha256 cellar: :any,                 monterey:       "28b37c480d1d842aae2e4b9c797185c5920ab08343e00c09a7fd64163af41f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3058b5ebc80cedade8cf8118f91c5f6dcd3e6af8b3b696af1a0f095dd08bc194"
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
