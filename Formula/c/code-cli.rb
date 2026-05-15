class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.120.0.tar.gz"
  sha256 "59a0b1df599df9411f3f7b8768f9264f4d1527ad625a6ac5de5742c37a3e739c"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ed9233b1d507fe45422382cd4d85403106b735cea16ded8652e99deb0519881f"
    sha256 cellar: :any,                 arm64_sequoia: "d8b881e5a8a14864a816d3129e2dc87764f072b41d4958ad4256d4f4828cd87b"
    sha256 cellar: :any,                 arm64_sonoma:  "db5815f72853e1018427cc0a4f9cfc71c3bf22d7a84d201a150552a3ada74dce"
    sha256 cellar: :any,                 sonoma:        "07c5f5a8bb3dd2d80cfaace4e385364649216f65aa8e507a7b0788407f394116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa6f338213408da421522074ccce3490d11bb27f427eaaada75819b61a6c28d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df41cc25f2abf7e4515f2232afa245accbfcc63cd8b00713c47e8ee90ab2e70"
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
