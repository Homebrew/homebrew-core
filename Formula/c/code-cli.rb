class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.83.1.tar.gz"
  sha256 "45c563424dfbff6e80c5621b5ecc1b7276141c944c1fa39401a98a800b576410"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ef8d97f487ae5aa02f46ef1ca8d11446a7199d975a2c51e7d08135d6b282a77"
    sha256 cellar: :any,                 arm64_ventura:  "5e3292257a40deeaeaffe74399ef7301bfb55ff080aa2d36930975d9b31295f1"
    sha256 cellar: :any,                 arm64_monterey: "f553027962dddd8e3dc282486f3b9717c5d67bbdab8983ed62ba7df0e03908ca"
    sha256 cellar: :any,                 sonoma:         "1862348bb34bf6d19e04e5dd35c42bee42c98d14189ee66fd24ed6c96ab88f2d"
    sha256 cellar: :any,                 ventura:        "9968928d2a2db7bd200087bae1f4304ba4ed97fb3d43945f21f22a8437ccdf02"
    sha256 cellar: :any,                 monterey:       "6b952fabd41551c06d2648c3e4083c076bcb1dfabdf20ba845a7f4abf58b3af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f70e1b82e1dbec7496e32704021517e5e32cc298d7aec73fad41d65396c29580"
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
