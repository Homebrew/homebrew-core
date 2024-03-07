class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.87.1.tar.gz"
  sha256 "f5e195fd8bb5965ed97de0dc1581a65a89e296f2e9dc0b1ae8b1603d84401c6d"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "713950a1d5582c137ef990f40b2e62bd46af4404745d183538ce7f522e796075"
    sha256 cellar: :any,                 arm64_ventura:  "f89b89d529516a8f59aaf6b732a952b5e224d70984fe0a63e5df77259a56c4d2"
    sha256 cellar: :any,                 arm64_monterey: "94d7bb08615586e95a832a4852f6066ca3f27fb0aa88d1cdf1914a5615e24214"
    sha256 cellar: :any,                 sonoma:         "1148384c46148e597853d5aab83b61875958ea3a1343fc2fd051f32005ba00c9"
    sha256 cellar: :any,                 ventura:        "ef1094a97d024b1538bdfb10f2482ff2460245907e1b36cacd344f20d30c06f5"
    sha256 cellar: :any,                 monterey:       "d4f7f4a029504e3ee427c09552f841ff751785cb098ca04f21d8f395f7d9c4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6765a65d4cb531633e668a9298ff975628b076b4f9f287a436e3fdefb98e8081"
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
