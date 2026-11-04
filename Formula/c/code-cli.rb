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
    sha256 cellar: :any, arm64_golden_gate: "3277c74354b0a6b282915465904f6e5bf3945f17b4ef0d003e1e65016d40b43b"
    sha256 cellar: :any, arm64_tahoe:       "ceaceb714f07f4b2f814fc0bb18604d3a019f1277d1acbfa8a3aa140f143c91b"
    sha256 cellar: :any, arm64_sequoia:     "a1ca70166dc6931c28265f78f724dc0eb58abca74b073e05e18772fd4c63930c"
    sha256 cellar: :any, arm64_linux:       "5c997f578d59b2a76062836797f7410e4d027ce3f7ec29ef170de9da4d05a9b2"
    sha256 cellar: :any, x86_64_linux:      "d8ed58838479d67b1cdc1a7606abfe3b7d52c5550a2eea122ae3d7c2ccafe1a9"
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
