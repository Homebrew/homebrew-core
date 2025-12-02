class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.106.3.tar.gz"
  sha256 "1b8530e60339963f5a12601db3191fa1f325a210148dfbea00275813583d69b9"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53523fb819b8fc35490e0d6489c76ce49031b0f0587dc4d23fe088b90055be2e"
    sha256 cellar: :any,                 arm64_sequoia: "68a706a45790b53998620c7d4cc2bed03d421bb1f4af54f43536a82c3dffed51"
    sha256 cellar: :any,                 arm64_sonoma:  "adcd649af912d3ea025de2d768dd05a88eaa5da1b1fe6262c7c0f1dcce0b6282"
    sha256 cellar: :any,                 sonoma:        "077693e33a287993dd697cfc5e4f61965bd616459ae8248dafa0cbd8f39e6061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3fa79fcb6c7b3c6aa3362bbcb225d60374a6bb5fc774d1547cceefcc0abdfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2bdf97a9302773fce87090d26561b6017ce6dcd2939072993346073cdcd93f0"
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
