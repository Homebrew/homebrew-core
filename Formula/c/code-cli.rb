class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.147.0.tar.gz"
  sha256 "b3b7d5f314a963eba0dc430bf3ca88212a029e9c373a517a8a4d5e1872f9f292"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e24341534db24864d57784a27d799a664e3bbaa38b315c1edccc58872d4d1758"
    sha256 cellar: :any, arm64_tahoe:       "04afe8071ce89c98fe7e659176a05fae9065e3802e1168767c69906474d632a2"
    sha256 cellar: :any, arm64_sequoia:     "43e33550e9219aac520b49d8c3c73f7a398798dd22610bd89d82105166be927f"
    sha256 cellar: :any, arm64_linux:       "fd3d5e27435be3fe081e8672596e5de06c21561f014b171467091db0d8afd10b"
    sha256 cellar: :any, x86_64_linux:      "1ae504cbbe2a5921a8939ae2d7660efc0d6e98a5fee64268706d99d491bfcb00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    cd "cli" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"

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
      formula_opt_lib(openssl)/shared_library("libssl"),
      formula_opt_lib(openssl)/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
