class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.89.1.tar.gz"
  sha256 "fee0a6b8fd1a06a164a737050e839fbb60cab49ba2db48215b59c62a06fd7ce0"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65f32e1198dc2ae8f92c67175a3c0e61ac7386153d2fee1c1014da62e8433035"
    sha256 cellar: :any,                 arm64_ventura:  "6c0e83540fb2f8eed2db631dffcb2ecf4ddec4b494b020ee01fecab6e2bf15b3"
    sha256 cellar: :any,                 arm64_monterey: "c8631116033fc6a57b6adbe02ade4cbf12fccf103ee750cc510dae7a2062c050"
    sha256 cellar: :any,                 sonoma:         "aea810beaa0aba8081460462b355335f7b740020c7a3529ccf11c615d9aac17a"
    sha256 cellar: :any,                 ventura:        "7f35e86b9a5dfb3d92a38471b0aba8e8fcf5e7ceea9f09d3900f6fd1c5c266ad"
    sha256 cellar: :any,                 monterey:       "3eca4cbda98fd7dc2dfaa5303477f72ee69de138678051ab77cf81345fb35f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9694145ed85e866f6c0f5893ed024e4694bb8e8294a8da78d21eda6755e5b7c8"
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
