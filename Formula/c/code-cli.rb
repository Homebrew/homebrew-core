class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.109.2.tar.gz"
  sha256 "73e42ad18c090123a4e535aa79e3f66d7590bff50bc8cfdfa4a7a04af4746039"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52b263d71679013c7980b693e256fc770dcc3c5010ee68b6135951fb8cd09f89"
    sha256 cellar: :any,                 arm64_sequoia: "e34ae601b1e910863e67db21ca794397ec7abca5a512e46913d4eeb29c26851e"
    sha256 cellar: :any,                 arm64_sonoma:  "c4cd943678586f48d20c47087ae00985d291ea179b91f9b21b38e843be8312cd"
    sha256 cellar: :any,                 sonoma:        "34acd03fb68b20f3de9f87a457aec62acdcdeb80cd118822eb2a04ddfe2d4f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238c8c94cb48a635fc0a8a299a4e99fe62742187f861cb71a82cfc70fb493249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6ab2b6a732882108c2f360a2388bbb599a5c1c50f49d1de46ef6097ea378d88"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
