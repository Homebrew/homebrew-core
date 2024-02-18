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
    sha256 cellar: :any,                 arm64_sonoma:   "9c6fdf88e7e435bbf210ca9e97b19b57fbe3fee66a2a9eb4b62d88d63a4b41c2"
    sha256 cellar: :any,                 arm64_ventura:  "99b1dc582d7d326a346fedacc296cec1d0092ab64c5cb82537a3c535d68936fd"
    sha256 cellar: :any,                 arm64_monterey: "d41519c435a44021c83f3082f6bcdf9354228fd8dd4b2bc47d66a0d7d692bd67"
    sha256 cellar: :any,                 sonoma:         "ce5f121005a9cea60a8a25c722e360997f463a061a7f8d64618a5367d31f78f1"
    sha256 cellar: :any,                 ventura:        "93bafb31ac89ba0aeaef68e4b46733278adef92ddcceedf1d0a1a78591f144ea"
    sha256 cellar: :any,                 monterey:       "43944bfd4f9891cb63ffeab76bb12e9ded6ba93ce4de939991d26cf4aeda3471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6d83ad7c6f67fd73cd59fbff9faa976e7c6585365a3874bfaca3f20ed0cb43"
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
