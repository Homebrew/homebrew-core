class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.126.0.tar.gz"
  sha256 "a6c23fc5243c5b51ef128546aa68a394d46d0b713535c8c3355ae2838cb51981"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1f8f9d36fb6f9457f2995859fafa17842970a6e4fa68d1297e1adbf74a07f0c6"
    sha256 cellar: :any, arm64_sequoia: "330bba9392985441265bf706062f8660d331170802e17f002c7fe1909aa961db"
    sha256 cellar: :any, arm64_sonoma:  "405caabb0beecb543742d56bdfc3f13c1977096ef298cfb508134f3af67b6402"
    sha256 cellar: :any, sonoma:        "bbf714157ba05f398888e20e20d4f292b04814cb9be6922141cfbcd07e407339"
    sha256 cellar: :any, arm64_linux:   "6cd26c0071249f8e4122542f7427f0fff61a3bf1ac153b6432109cdcf089f2c8"
    sha256 cellar: :any, x86_64_linux:  "cbde1e26bdfdf040cdf422fed6ef496343ed2d4d59bb45e5b5c9a870165e89db"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

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
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
