class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.112.0.tar.gz"
  sha256 "00457e5e79dfaabaa688d1be0d1c116ce0c7a5b2bd49db34c00cb35f5f8ab5a3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6095e1ff8a0ab7ac145107276fe141e512430d59158fa09f8d0aee5d5fb1d50"
    sha256 cellar: :any,                 arm64_sequoia: "2fe4a621638bf87e0281edae14baa185e7f8d8d3b755012aa004b32886f1e7fd"
    sha256 cellar: :any,                 arm64_sonoma:  "7177bf87f936bc519ebf3331ae333273c92dfbec09152c5058a1de7b1154faaf"
    sha256 cellar: :any,                 sonoma:        "ea6ac3bfcd73d59a53698ecfbf446cba858ee605a58b6fc1348a3d2ad088ce38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf6347d76ae6cac4317c6e0e460c703d9e4ab4e5cd087ebed6fba9f49a90a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ba44515fef3f28ea14ae175d63b8d3c979b13c4800d674423839d40c1f9a0f"
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
