class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.86.2.tar.gz"
  sha256 "c0b8fac76b0836e6cd5332387d1007c3f959c2cd4c69cd90eb25c79311708375"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3cf3580543ec518a656a52a809620041d1befb1586b91aa9ee11dc74c2f55d28"
    sha256 cellar: :any,                 arm64_ventura:  "22283faf128cd0872b588f3d59d3eb4d7a52a5d3afe7666cb6af94e734234d09"
    sha256 cellar: :any,                 arm64_monterey: "9e134ddaa45d5835dbe166bb29eec8981fdaeb54f7092963146bf6d5207a9218"
    sha256 cellar: :any,                 sonoma:         "470cdf34718e921502c48d99acd81925901fc5b83e9bb2447a0ac92c41998c5d"
    sha256 cellar: :any,                 ventura:        "666be66177296df26a8aad49fdce42f900cae6b728427db76454fdfe3047e494"
    sha256 cellar: :any,                 monterey:       "ece7a2d352974606a91f0b7ae9481addc5ca01b703b814fea1af60715cfd366c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6c201f1896e61a2cd3d724c912ad1df056fff901c2f8711d2b9868cac8ceac3"
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
