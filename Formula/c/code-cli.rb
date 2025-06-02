class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.100.2.tar.gz"
  sha256 "de57439ffcdfe70020d6c2397b0d62089cc01fe7fe612a65649cbaa5360a6a81"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4766661e79f0b06e51430dc219f6d6797dc808fc5b39f8ed57459b00c6085e6b"
    sha256 cellar: :any,                 arm64_sonoma:  "4d74748805d84efe979a5bcb40e111abc33df861655f6c581d6cf1af46e3b1e8"
    sha256 cellar: :any,                 arm64_ventura: "9bbbba906405d4ef6e2401e57f84dbf293c59ee36f8560dd2b07196304b72b34"
    sha256 cellar: :any,                 sonoma:        "36689ef5c948a5fd48770a2e237908605bd1b5b090b665bd2444063ad7c5c680"
    sha256 cellar: :any,                 ventura:       "b8af28ceca682daf309816391b9033402648d875c42e9dabf271c2ddd2794f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f108e481152f5fa1e5244383b3b069c1d90c7a841c2696932d361032966fe94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd686f546c949211fe8cef99a22633042f99ca07241993456a9b9b908a46275"
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
