class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.81.1.tar.gz"
  sha256 "2e25a4fff2977f231136e6283583f986ec45604187f411eba1617f4584a32b76"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90633d4012202de2fb295e09ee288eb85aed3873d0c3e234b9164bc1354a09b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77bcccba89b64a831b58ab59f01fddf574ebb289eb13e32849651c783d22c142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c126e53743ec4a5bafa55506ff75abc2f9319e1c164e0c65eee6aad20e42492c"
    sha256 cellar: :any_skip_relocation, ventura:        "257ea85fc3ae9ba07d34c052a9958dd79e97f5d1ef484844bfef74848cf490ca"
    sha256 cellar: :any_skip_relocation, monterey:       "22b0627a81190a9c6a60d8794ae7732b9a695e2634318732f266ed540c88b790"
    sha256 cellar: :any_skip_relocation, big_sur:        "59e2501a92334c116c300754d1c1ba19ffd5309cdab2c7ba2c2f5b5642f23899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d75c6f5bc732e934b377c425cbbcd536f314d8b8333b2a4491338faebb776fe"
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
