class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.79.2.tar.gz"
  sha256 "2719ccbb573f5b7c174bd5bbcad97d3fe4d917e16327a6b72162ff7014c17c9b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c90660ebd5ddb45289ce1896430d26db7495dbadd8d271fbe6a3e712f0755896"
    sha256 cellar: :any,                 arm64_monterey: "7d42b951ff4a5d6e3dc538ddc67a95078844c8d9ff703baec77de7fa8d47c232"
    sha256 cellar: :any,                 arm64_big_sur:  "cf44e09b3caf340d89a03ab2dd7c242dc62c4cae3709d8b542d38f9e064ace98"
    sha256 cellar: :any,                 ventura:        "739c011233b1232deabd4c3d96eae6209fb6dceac1851ee359fea650fd7fe031"
    sha256 cellar: :any,                 monterey:       "0e7f8d313260c25a76c2fd4287888972ffd49a39bef5a08c09f6015049886505"
    sha256 cellar: :any,                 big_sur:        "a44e0b9b7a89035489a49de5e12b3572b663a79e4222320ffb8d4ca5d55da999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ea22521240e3e51d456fd467f01a5479c1f38ab7aade0861e8f19d1f5815ef"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

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
