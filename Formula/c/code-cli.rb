class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.96.4.tar.gz"
  sha256 "cbd16ab3cfe5322a532899f7c7ef4a203512c70f464c405465e6aa8b85a4c22b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72ad044e465e20c4b6cced4264620e9679a82652af4709095752886a4087b4a5"
    sha256 cellar: :any,                 arm64_sonoma:  "9944c2b1ed586e8e0469101f6a6e88e0f0f045c160a513d37f25da30944c8724"
    sha256 cellar: :any,                 arm64_ventura: "00211bb40d5566559417232d153b025275c469f42531c382ff90e0504e1568b7"
    sha256 cellar: :any,                 sonoma:        "8bf63d6963aa718d880092b55357b437ee8395d4b7107debae659465c4538038"
    sha256 cellar: :any,                 ventura:       "69025941290eefe40a6e54c777e0f2c982d31c087e11b403e7b802abe822fb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e303fbb4cabb8593b3fa51ffc6ab83f37eb1f913808d75f7052ea239f2f6faaa"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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
