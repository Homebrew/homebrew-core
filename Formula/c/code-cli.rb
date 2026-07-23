class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.130.0.tar.gz"
  sha256 "4ae0a5ffbfe669582991e737afdcbd04a4ee37e568fcb1f49f169239d0e112f1"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e01fdf7efc624a13389965687659f85185b82989ea0e7b45c6ab204a9db254d"
    sha256 cellar: :any, arm64_sequoia: "00035c9106e40d5ce0b5b89db843f8608ba46118fd224539ea4d12b86ee42b95"
    sha256 cellar: :any, arm64_sonoma:  "291d8f3ce3e2f29d1e380a31315bae3e46f6d446f05517c1d1b14dce110521f1"
    sha256 cellar: :any, sonoma:        "dfff751976964b156b5c53d6dfba4966cb0b920e354bdbbfeec86ac4c1136d29"
    sha256 cellar: :any, arm64_linux:   "cb0330da6dde21d33525d6e6434998d8e1a020295a2d63f34f2518013971da74"
    sha256 cellar: :any, x86_64_linux:  "16d8c559278482394b7f08529d72a5a4a540af1c7e347963a2482bed00974b10"
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
