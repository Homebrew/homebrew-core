class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.78.2.tar.gz"
  sha256 "30c98b459e2cded101d26deb050cbc554167ff0986b47229703e9d4acf74f48a"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eba5c9c7c8dec79c9920b304d6c06047cc302e6d59646d6db51ec240f56122e8"
    sha256 cellar: :any,                 arm64_monterey: "0e2e9b4b006cd44214a711cc50b627ab43a758a6a623f73945df34f28554f71d"
    sha256 cellar: :any,                 arm64_big_sur:  "4e3d33e1668897e6e7e4afb778bbf442da21c5add77d24a42cae4202a08ffbca"
    sha256 cellar: :any,                 ventura:        "bee0be050e964dafd7c59ce7f2276882c8ab15023f7c4de519d7f5fa1824e145"
    sha256 cellar: :any,                 monterey:       "3c56dbe4a6cf437f73712d9b43f2451e1ee654c1ad328592b2f3991146d54514"
    sha256 cellar: :any,                 big_sur:        "e5457377a61a783881ae9ab15f803b74376be32d4dd2e32f43b9a92b87feb43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c0b5fc05cfd9c5ed11b7bfc9fcbfcee6d519a6f4e0d2a1b34986ea55bcd9da5"
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
