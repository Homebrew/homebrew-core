class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.134.0.tar.gz"
  sha256 "aadbaa0830a4e0bbb4224f590cef9bdb5e0c3378a278bca51d0ffe71948fdd35"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b72f55788f15e5c70c0539914f7a8f651743b77ccf8a3c1f8bf4e42394f1f366"
    sha256 cellar: :any, arm64_sequoia: "a1d986577cd99b8bb443959992e20013e56cc0accfb50dd0991796edd096ddda"
    sha256 cellar: :any, arm64_sonoma:  "58cc9c987731b1f13496e9978fc199fa2c694d0ac13ea1faf02345e605f538ee"
    sha256 cellar: :any, sonoma:        "3fd7d0b7c56272d7e4602da5e71796a6c7b540956625406868a7cd4f6f0612ac"
    sha256 cellar: :any, arm64_linux:   "65734db137136466afce44903cac3a91f8374da4bf46e01761b005c93b78c1f4"
    sha256 cellar: :any, x86_64_linux:  "a6c9052a925acb78afa38db4c8f22cc6b86ed4baca8e03cfa0f8d66d085e8ea0"
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

    # The 1.134.0 tag was cut after `package.json` was bumped to the next release.
    odie "Check if the `package.json` rewrite is still needed!" if build.stable? && version > "1.134.0"
    inreplace "package.json", /"version": "[^"]*"/, "\"version\": \"#{version}\""

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
