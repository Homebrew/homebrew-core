class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.94.2.tar.gz"
  sha256 "398a73d3d1ff1b9e962b461518ac4506c7970aa8a99030060287651e16a804e2"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9c9f1abbad8ce55d8d3289c197dd079846d2eb7700423c2f902c316184bcb42"
    sha256 cellar: :any,                 arm64_sonoma:  "bd9bd4ab4f9eaac5dd0f317b91307c3c1f9f24e6be7863c88781b12ec8ab0355"
    sha256 cellar: :any,                 arm64_ventura: "55d589db81e6d82da4ef61681a4c5c482c0d80b314317824acca9440e2f06280"
    sha256 cellar: :any,                 sonoma:        "317585b9f33b95ebf02e5ab528bf79fb737e1b54d1269d9319dead89c086cb42"
    sha256 cellar: :any,                 ventura:       "343a4f3e077f7a2babab150c694d4d6f05628acd0109046e25401d9b79e417d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58423be0365eb6002b206a5ed2085e2911a621e7385a6039e4cf059fde342aaf"
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
