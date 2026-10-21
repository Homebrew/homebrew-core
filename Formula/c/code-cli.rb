class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.142.0.tar.gz"
  sha256 "aa655902cc06c5773644f0154a9a561eb3efa092bae440eeb0b4743115903805"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4d8f32ec23a70f181f6c6127089761aac51382e5f8a7ddfd0d6e486a576dd0b8"
    sha256 cellar: :any, arm64_tahoe:       "5eaee872412ea1a440f74a7ba93542ac99bcbef31b10a39410b86e84ba84862c"
    sha256 cellar: :any, arm64_sequoia:     "78eb37682b50f472eb736969848330cff0136d2e811f0486a99f643b3c3fa1d3"
    sha256 cellar: :any, arm64_linux:       "5f6a002de0c73c1d5f7c89635d1ae81cf222d3057f6b2070c46aec228e55afc3"
    sha256 cellar: :any, x86_64_linux:      "385df0af4a9b5a5d5beff3b2144292ce49337af6d3a5fd92494680c8177f487e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

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
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
