class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.90.1.tar.gz"
  sha256 "758283885cb6746069263321fa34299de0b6722eafa19034d9c446268d780c90"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9fc0883546ae39289e891775e5a744f42a4f436a395beb41a7ef533c69eeaa73"
    sha256 cellar: :any,                 arm64_ventura:  "3edd38e823fca9b7969ee374b532fecad96595482c634169d65fe2a549c0a3f2"
    sha256 cellar: :any,                 arm64_monterey: "00259f3ca87781a56336a40928819896ebdbd59266e65bd1c0766c01fb983b6c"
    sha256 cellar: :any,                 sonoma:         "ebb875ca80bfe1034934c9f9340c1a5e0e710812f6932328744faacb242ae544"
    sha256 cellar: :any,                 ventura:        "d4b6e83d57b25032dd05cb2426aec379eeefa5455c3191002235cca306da7ab8"
    sha256 cellar: :any,                 monterey:       "dcf1364c6b5b0d6a9bdd11b5cfbd626df3542258502bc31435fefe5547d16642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "197aceebf38d984d74bdb1ae9908c4b5133f2313fcc9787b8a30ab92b1a4d2d9"
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
