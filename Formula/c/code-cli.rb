class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.108.1.tar.gz"
  sha256 "e26f0c16b8a23a90d571b0868d099d35e887f4c6b9ecc91efc269dea930e69d4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc5c62a426276b944053bd85083c36f5453bac37d20ddbb11e7588f6526e5658"
    sha256 cellar: :any,                 arm64_sequoia: "949f2bfd225811d7c53d1bcb6ac578928d16df45c88e6b660ef4ad25b7b4e890"
    sha256 cellar: :any,                 arm64_sonoma:  "d60ee6310efd2ef71f4e0ce591a9784600ebaa1bf439169dbe4c5edb759cbab1"
    sha256 cellar: :any,                 sonoma:        "49023757b62e05bb60b081331c26e0633322a376638accf0eeebd38a6bf494f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26efb840dd7c86aef2b53c864ca29346947f18cf43f73e8e6445558fc9570211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fa49f1766ce404c981d8eaeced24797f47c7b047cc768004b7e917cdc4de34"
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
