class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.119.0.tar.gz"
  sha256 "42fe79bbbb1265f637812c83cb65568a60bdafb2e66936a49ac993dec22cf3f4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eec4278aa304ba843d5b671771c9985276f5ed6a8adef56c85a5dfd67635e67d"
    sha256 cellar: :any,                 arm64_sequoia: "1db796f2dffcf441111cb24e3a20f0136af6f7736ee2d1382fd8e74e53131c47"
    sha256 cellar: :any,                 arm64_sonoma:  "084c8b3b31c2ee918b2582ef090b0853fcdb5895ba7d06bf42b7d505ec93947c"
    sha256 cellar: :any,                 sonoma:        "b0a22f5f41cb85d0159cccf1e0096767f0314a2a5a593007002d6a223cd8d531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4ac5bacaf0d5fd6102673281083c3e884c25d3def509c975f0bdc1305133b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c350fc29a900ced9d4a7b5b83f99e0b73a9bc2bfc2e3668af70917881a47808"
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
