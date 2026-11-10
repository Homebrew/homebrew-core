class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.145.3.tar.gz"
  sha256 "2b4428767c13fdd76e9439d01846195a620dd4d47c351c0f99a68eba3a252e8b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d2d484fb86f4f1ae050bbf818c8c1a75c0528f0fc764d5d09acb3c71df932522"
    sha256 cellar: :any, arm64_tahoe:       "e857f65c34c5792810c76235fc72d37101f8bcbc61de7039b4bbb352ab405a3b"
    sha256 cellar: :any, arm64_sequoia:     "e1a1e82c00612cb41d0762460cf7769095f8611ad01b0f3838685472d9109dd5"
    sha256 cellar: :any, arm64_linux:       "7ec3bae5d572a95fd9fc85b9989f2cba52c1da8b87356d464eb2dc28e471b4f7"
    sha256 cellar: :any, x86_64_linux:      "b3b58c9634a229af67820935a843c6bcbcc5379d32cde16ffbbc54e77c2e8752"
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
