class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.146.0.tar.gz"
  sha256 "7a2fadb7ba458eaac03da1be1d70aa70903fa9377f7f3a367facef3e237c1bb0"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a26acc977b0b11cb57a53f4863f17386f8f1f555c05bc00773f03098f47d6474"
    sha256 cellar: :any, arm64_tahoe:       "84648475ef350b499ac958a26edb4e38653db6c31080c3a633cfaf6b8b1eb11d"
    sha256 cellar: :any, arm64_sequoia:     "762a334b87a027828d8d06f65513b921e64351a02e542172138b6ee971d75f9c"
    sha256 cellar: :any, arm64_linux:       "694a0fe188cce553380fddc10fcaa4672f767c71c648bb86778d759cdd62bd23"
    sha256 cellar: :any, x86_64_linux:      "55a20cc33990f4b5745a699b4c67f0db81679497598b6408a7a1d2fe6a884614"
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
