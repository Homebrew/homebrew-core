class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.79.1.tar.gz"
  sha256 "bd6dab65392a9975ce656190308809d3e3c71e6d2f81091f7df614d71441ba8b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f75df1b568e6a70128a0ac2aaf759b5c33b72989bb1998c10eb96c4ae041666"
    sha256 cellar: :any,                 arm64_monterey: "eaf36c724a4e052ba49bb36b58c49c6815cf99846f43d6f20a1082b01b733437"
    sha256 cellar: :any,                 arm64_big_sur:  "4c9620874178d9f660e227e44a9829690b1c291c360623b5fdf44cf513fe6da0"
    sha256 cellar: :any,                 ventura:        "5841882a9475af663c9ded621e0477081c86f0f969240ca19196e6a28daf9df2"
    sha256 cellar: :any,                 monterey:       "b3a56c6cce8dee3313ea02826af828a7a6a2b5125334a9b1229e11f60011fd1e"
    sha256 cellar: :any,                 big_sur:        "f3e875614a44e3ae1a52f91acadbfe940a71022fe5fb31b8d95885c6ab3079f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "509a53ebbb08ac733d6e2cf072c216b9fe2355cefa788550e970e6b372dc89c5"
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
