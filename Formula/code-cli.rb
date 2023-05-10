class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.78.1.tar.gz"
  sha256 "6d1a6f2515e30e9ea90084454b7fc18b793d74e66bbbd51b56143fe72bbd9497"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "613c1a6cc595553eb8e766317895849124de73356d4f74322233a42ad39dea91"
    sha256 cellar: :any,                 arm64_monterey: "0b85795bad6c37daa7decdd20c22487a15ef64dce2073ecde57f390fda9df4e4"
    sha256 cellar: :any,                 arm64_big_sur:  "02ec83d03be17dd3c54d44603efbef8138dc7da87a1ef9607036810c98c2627c"
    sha256 cellar: :any,                 ventura:        "b8cfa92b3b5bc89a76ba5a9aeaf426d1d9c4454cf5de3b253c449a3a61c0b624"
    sha256 cellar: :any,                 monterey:       "61a31b1df94385ed47b5f04923cae9ff7628607f5178206d977a90ef8229c469"
    sha256 cellar: :any,                 big_sur:        "8e85b5ffda36da4d7432feab6d68f61e63c57b4e698ab84befbb1135ca32a96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a372d9539b48d22cb38eca5ce73fc6831c3bc9b01f9b3bf825e3a05ec811b87"
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
