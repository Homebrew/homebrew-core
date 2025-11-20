class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.106.2.tar.gz"
  sha256 "41d6a9e20814ad9629943d5fa0157cfa9e7090fc4a62cd3be7fcc9be4b46f410"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27fa9d213c53ec3c7072cc360c69236c7cbdf4b905e9dafee7d1b40966a95bdf"
    sha256 cellar: :any,                 arm64_sequoia: "251302d4db20a7af21cbf21567fbde336552df3e9f51e0b01cd5f888844d00f2"
    sha256 cellar: :any,                 arm64_sonoma:  "717e40fe100bc863a6fec1e4c5a6768692f90286a64a90e7987cc5bbec282562"
    sha256 cellar: :any,                 sonoma:        "5ffb1727b78f0216af4d2ac62503731217010deb798816e9fd1010b31db898ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f15126aeb688e8d0137d8857af2c461be5d9182586b12898c1ab43f3d9b7654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f4282c0954692d348f973e8958ba5032463a9f1fa4dd3a7b81de2b26f866fa"
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
