class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.136.1.tar.gz"
  sha256 "d8bdcb93b1c497fe7c51c0ddeabf26d649e64fad890cf326aacb2c6f121472d4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "477dfcc8597ff10b6ee0d9b3f79e6dab382080c5c0adff6f6fc83a67dd64cf1c"
    sha256 cellar: :any, arm64_sequoia: "0f1793d1e35689208d5291f0b6efe5b459da1b53768c1304d05c67cd39fa1a61"
    sha256 cellar: :any, arm64_sonoma:  "d28718c47c966d94417cd1b80843d25c303f7c3fd14ea2629b4278847b894853"
    sha256 cellar: :any, arm64_linux:   "50025ca56002778a5178a787eab5a296dee27a85914823c3c79ff0d23d16b03e"
    sha256 cellar: :any, x86_64_linux:  "2d9f959e4720b8e019deb0afd7ed86d691f10236f7039d486af9e765c3ecd386"
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
