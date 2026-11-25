class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.148.0.tar.gz"
  sha256 "6dce37185f4be39d8e217e43f4008212cad38d069e1920d079194c8090f78b45"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "b915cfa74ac689ecbf9754fcd2fbf3e2bee7b200153ced24df2ae34a2e73ddea"
    sha256 cellar: :any, arm64_golden_gate: "f637713e941ffa49543e2a89696a23a30ff1736017c9bd618a7a2d91a6acbc03"
    sha256 cellar: :any, arm64_tahoe:       "338f69e1f95e1556f5b26c34ec6cdaba1894a701d3d6aba6f3af3bcd63ef748d"
    sha256 cellar: :any, arm64_sequoia:     "033f44ecb9ea434ca7bc56d932d8422d0318c04b8407d7017b2a2d2c79e9dcd8"
    sha256 cellar: :any, arm64_linux:       "bd6989c6f2b3d2d4f0703317c8145df868d7b7deaffc79e19152c7dc5150f9bc"
    sha256 cellar: :any, x86_64_linux:      "270e745cb9de2d63fc0111ab70263b56ee8c9a3f11a22543fbb31046c7c61769"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    cd "cli" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix

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
      dep("openssl").opt_lib/shared_library("libssl"),
      dep("openssl").opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
