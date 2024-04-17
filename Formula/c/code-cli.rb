class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.88.1.tar.gz"
  sha256 "c66fc273b9105f400438d236bfdcc3a2d37c4189e60b8b9e9cdedb604668c73b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10aeee8178c5c3efbf7f04a7cfdb2fd8acb767d924d17180aaf553945e11c70f"
    sha256 cellar: :any,                 arm64_ventura:  "db2fb8934b1c5b20bfd0ebe943ce056a05c05525263c57901174a6071eabcf3a"
    sha256 cellar: :any,                 arm64_monterey: "a89d0e8c70e5a38012b55f5ec22038eca789ed06d4e27300713e4ae435527cc3"
    sha256 cellar: :any,                 sonoma:         "1eeb80490d4a33e056a3517c0118ac50c5ca0798de73b8ca95d6279d440706d8"
    sha256 cellar: :any,                 ventura:        "a03823107f7b6c1c69e1777061964fb9f6e32502919c0572a2206fd157850c55"
    sha256 cellar: :any,                 monterey:       "c0ccefb50eec93c148c1e4cc4346e769c3c03a7ac07c73903de736ee4a649388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8550863495f5d4423081c1ce97afc77b70c214d6cf6846203e9863dc69aa9eaa"
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
