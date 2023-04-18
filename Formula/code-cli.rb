class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.77.3.tar.gz"
  sha256 "3d1c487667fe543c860254c512b9ab4ade4149286c43819b6aa1cdb729a8d781"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f423149ac1877d69d1c0ac4bfef922e17102a013644d9e066c12570033fdbed"
    sha256 cellar: :any,                 arm64_monterey: "873a540a56dfa00d393d0fd536a5eb94a1df6b174f45b84d498e4c23770fb584"
    sha256 cellar: :any,                 arm64_big_sur:  "f14b1f9bbf6986e4e77c3679900ecc7cd2854519dc14ef46cf386e3559260ee5"
    sha256 cellar: :any,                 ventura:        "d1363c67693dce2c7504681eb1274de2f01c4f9f1e418140f5727661a0b63fca"
    sha256 cellar: :any,                 monterey:       "40723b2423a2862853990d41716212b27f82487668825477a97962cc3a2d545e"
    sha256 cellar: :any,                 big_sur:        "6b46d730672a448d6a789fb031d3f17824f8021992ac31b7c972967f90b23632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7bf7f9ecbc539fad54f4d65cbce7a5ca911709f97ca2c80f43be17d5de0b6b"
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
