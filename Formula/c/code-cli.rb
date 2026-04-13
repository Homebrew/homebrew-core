class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.115.0.tar.gz"
  sha256 "001c56730d6c4302fd1cc1d06e6aef58d166cd14bcbf1aa2cc386739ecbc8f73"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b14c5133d7dfca0e08e61a1613735bb4c826a422f5bf71bfb040b1d3cdd688d4"
    sha256 cellar: :any,                 arm64_sequoia: "f6a3ee49b12a6e5885572b7ac359d602f0c98867a849234f75a801ef0134f191"
    sha256 cellar: :any,                 arm64_sonoma:  "acc8a9c961dcaef40f40771b0cbaa4c6bf05d6f569fe6b0e46a6a558755b2bbc"
    sha256 cellar: :any,                 sonoma:        "d097f9ab49007bb725fbb83e0d78aeb4ad28140c04c325a194f336aee5a3e8b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c877a17a1f12452269ae3e53ae526b5a237a403a4a9c9d1b3ae5aeb8704e9294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8b9ce41837b732e6a37258337e7bbc36c1485624b51c229b57c62c1fbc791f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
