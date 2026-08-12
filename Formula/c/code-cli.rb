class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.133.0.tar.gz"
  sha256 "3dc7c39e3c997a2796f18f195566c416995fc2be82849de9188863d30670758e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e5437749c861e9b228d6508b73dd044aaf8976df260a3ccc0910c160fff2912"
    sha256 cellar: :any, arm64_sequoia: "5a66961842b9af3080da4a5eeb48d2361a465a27c829b53d4059fdd6ebc9ba6d"
    sha256 cellar: :any, arm64_sonoma:  "8aaf39cfcc9da6e80c734902e9a6b15086d20d917909f362bbe6627bcad6e262"
    sha256 cellar: :any, sonoma:        "0739e9ea72b666c24c12b80d4c19a82278d38149a998672698db5aafaaf5e3de"
    sha256 cellar: :any, arm64_linux:   "8efd0b91b2d7dc7221870458f7047572efa88a3fb91695318a9a91a54957612c"
    sha256 cellar: :any, x86_64_linux:  "72afa44009abce1f6842ae471cbd26cff72603be2dc9002398b5a2d22744beed"
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
