class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.145.0.tar.gz"
  sha256 "26d2e82ce4123ff3904fa68a30d7a1d43c0a1023d9844182abc3ebfa7f710e62"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22ecd254d3304d8a1f4805ba0463c001d452c6e250e60a8625b721d3d2544e56"
    sha256 cellar: :any, arm64_tahoe:       "1c5ea97f937518d47136fa0c23e0a894cbbfec346d6be2220d2c7f7982bea482"
    sha256 cellar: :any, arm64_sequoia:     "b1d14508fdb43b695030758b2054a6da89f07cb062ec55adf665b082cbac8e54"
    sha256 cellar: :any, arm64_linux:       "5d055d35969c7f7c2a5787e5cd5d2f1073d8fd258acd3a7e7c15332ae4e20394"
    sha256 cellar: :any, x86_64_linux:      "71e01083b38bf6433206f9751093a9d85e406665372ab8fd6f97362408395ca9"
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
