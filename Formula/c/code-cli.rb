class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.85.1.tar.gz"
  sha256 "b16d2058a8961bb2753f6ff0d697694a670ff6f926b4b6ac63106c6eab168eca"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d850e214959a479c3b4c02b85bdac6fb352493bc169dd47b1a234cf6de9368e7"
    sha256 cellar: :any,                 arm64_ventura:  "e2c26b64504d4e64945821d68ba08d3c4b9d918d824f0360b75c12cf2be35bb3"
    sha256 cellar: :any,                 arm64_monterey: "61b899cd69d01f20c8d2de3642f0e77ec7127d3b501fd36bea18cbf6017545f6"
    sha256 cellar: :any,                 sonoma:         "894b4c3a5c3c56a8ee46a0774876318d9f1f33cae3c4ba8edfca8d2a0e57151f"
    sha256 cellar: :any,                 ventura:        "cdd5ae8e8de3d6635c30b33f7f22f012627af5d1d29ffd2f0ed3579fab57e05a"
    sha256 cellar: :any,                 monterey:       "12fb06a44e5cdf28cd34628567a1c8a9c1f8d72f8e126c22d080b6767a9f9730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba0a0c0b3708156bc7460bcc591154cd46241c8737ab04f6e7cf4eda6ed1b80"
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
