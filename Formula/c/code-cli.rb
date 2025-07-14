class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.102.0.tar.gz"
  sha256 "2d48c358a22d12c2bc024673d08300b3dd45c6859f8a3e4d16480100b16a0a31"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "649e59c589e70b484ad9a14eae672daa07ecbdd1c5344f22ff84b95a6eb7bd23"
    sha256 cellar: :any,                 arm64_sonoma:  "632af61a9334c7ca14b639391443c65bf7dfe1325028bfb1703faf6f215275cd"
    sha256 cellar: :any,                 arm64_ventura: "b92d3dad3b9136e133fcb3c858daa7c0ebd5689b535961250a38fb060306c842"
    sha256 cellar: :any,                 sonoma:        "7a329020dbdac66ed68c4413c37a0abb6370dd8d946982d5240d04eaba634e27"
    sha256 cellar: :any,                 ventura:       "8492fe465b4100873de5607742230481ff432154e755ba35dfdcac3a7a3f6c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a2a9ed0922b62458932163cdaa4714f0acf236e8e7b491e86f1925d6e2dbfbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d3f83c3aeef3b328d0c2da899b3bb58e30bb3b1ea97127ef69062cbedbfc62"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
