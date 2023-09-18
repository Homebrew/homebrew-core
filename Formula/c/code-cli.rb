class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.82.e.tar.gz"
  sha256 "726fd5dc8b1782c168cb3977cffbde591a6769296c87d8fc4a68defc2680822e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b1e421e7b9b58ca7c7328ebfa8472c9c4f22a26d34763c7d9ed798b0b8e61c96"
    sha256 cellar: :any,                 arm64_monterey: "3a9d14313c35c996d2115b52a23819316071a66ba16bf3b2a22ed0eb7acd28df"
    sha256 cellar: :any,                 arm64_big_sur:  "7a03189426e6c920e5cfb6238bb1d25b8087470017bdea56ee13d226a351ee61"
    sha256 cellar: :any,                 ventura:        "3747a1d595368ca24e5bc52a9d7a518bc65adb96daaa6b70bc375881d4e728aa"
    sha256 cellar: :any,                 monterey:       "77eaf26c169d410f4eb0ebdc867aeef1a6b80990e0a89b0ee16c33336cd3a6ae"
    sha256 cellar: :any,                 big_sur:        "0ebe2638e5230d2da44b5e9c386c3563539b8d0d0221f8843ea605e40877b8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f2b46c2adf2c06ff824502ba820411ed9f0c02aad9c8ab1039479ab02a3e89"
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
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
