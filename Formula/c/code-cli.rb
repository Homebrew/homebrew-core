class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.84.0.tar.gz"
  sha256 "85d5964044cce63870a51c973d2dc6a0f63a3f42dd319cdaf59259f309078031"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ffed69599e3c77a03dc16c1827a080c4ab7ad23929336cd3b4834aa5db319d53"
    sha256 cellar: :any,                 arm64_ventura:  "c73758416ca0f5893429bd5970fffda8d8a3374f38c5b5522453a9c122615539"
    sha256 cellar: :any,                 arm64_monterey: "0c54253da234197eb9623321e9099af7b580959b0e118bf1c0ff38b63d3e7c3f"
    sha256 cellar: :any,                 sonoma:         "3fed4a7774b219f87aadb85aa8dd11a338408e6b690169345797fa6901709436"
    sha256 cellar: :any,                 ventura:        "a86579a2a02d3445e1fc5ab73be491e843d951150637918639dbaaa16822bb31"
    sha256 cellar: :any,                 monterey:       "21a2602293351e81c886a829209b0b0920c9e6eb3d0869ec4b5decf97502fda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229d8186371aa655459cff2aaaea6fc1d26cc84470dfbb7a75760964cc02549c"
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
