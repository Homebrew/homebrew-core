class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.83.0.tar.gz"
  sha256 "4be78681d5009f184cdf3905d3c3c1caf3e95987104047660eb2203dc783a8e5"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2153596ddb70ae85d84b11338633e49dec241e83b8869378643b07eb53a54a47"
    sha256 cellar: :any,                 arm64_ventura:  "4630324ae5b42de57146b9330c8b3b607cf5da7035a3e112567ca6b8f31c5856"
    sha256 cellar: :any,                 arm64_monterey: "a441f5febd53ab7f8415c35b1625a720aaf6460662ce2d12895ed47fe6e80e2e"
    sha256 cellar: :any,                 sonoma:         "f5d82f611f35d5ad21a93af99b8059367f1139f8d8c757ba7c4b190903ea8d40"
    sha256 cellar: :any,                 ventura:        "20276c47651c50c4ea86a280589b913fcb448055e84af58a25b9ee0338363dd1"
    sha256 cellar: :any,                 monterey:       "7f883681aca5b70d5a0accc02edf72bf3762a3d6a13b50ce658839c33f136eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0395a1bb7edd26559fb07c6622c84d59245565bc4894f4d3a24632e13d68820f"
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
