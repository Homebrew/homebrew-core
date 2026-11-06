class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.145.1.tar.gz"
  sha256 "68f3687861549a8891fe68a8cd9812d243cf0cb2c2aa625037aaa074b618ec8b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a8dc423d40742ad54e47407f9a93b5699a563d9866a8f1011aa4f059c31bbe1f"
    sha256 cellar: :any, arm64_tahoe:       "750ffa24456448478a183f59d427bcc94a84c6bcab0a6aca64f4190507bf3363"
    sha256 cellar: :any, arm64_sequoia:     "58806cad6a710a00d75167325ee20f6faa7d5622b64f8ca4a4827823939b8982"
    sha256 cellar: :any, arm64_linux:       "a25bf86a80bbf9d9a558093c25fccfab8bea9fdbadcb226908a2d8a4bfbcd572"
    sha256 cellar: :any, x86_64_linux:      "862eec7d5cebb3f228ff0454863e780ac9771b5aa307e40c95f955bd814863f3"
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
