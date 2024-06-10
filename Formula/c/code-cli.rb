class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.90.0.tar.gz"
  sha256 "bb093f22235dce2083374b3fad56cd036228e96c29a96e1a9063c8aa7ef042e4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "29730c6c253416f28330051e33f9977aad6937f2757ce92a016227f2b5fd970d"
    sha256 cellar: :any,                 arm64_ventura:  "abc270be7650517c118bd6ef2c2a6b17a2e7679b54de812117e5c74a36b74ea3"
    sha256 cellar: :any,                 arm64_monterey: "7edcb6db552a2782a9d8e3ce27db6fd941a7cd1e71e383294ed212be18b6c78c"
    sha256 cellar: :any,                 sonoma:         "2b5873d337ef4d665142227c39d355bb0d1dbc184b547d6189d7ef5ff2f49d0b"
    sha256 cellar: :any,                 ventura:        "a0ae71cb8e3cf8b1d163e09726bd5f13dade5f055906c960e2f03afcfa868a4e"
    sha256 cellar: :any,                 monterey:       "8428a1e3ba7a75b75f5bd4dabd124134b282afbc71bf27d7081a96ccd3804439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ec2510a9441e43470c94e34b5b0556544581ee2afec452eb348529feca8bc06"
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
