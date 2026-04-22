class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.117.0.tar.gz"
  sha256 "d5fb94e45c3df873bd7059eeb82ef98762314c1396c153b794b125c5f736dfa7"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2684de6b295cac0269fb05517453b51a8970ca821647ca393cbd47586a02c9a5"
    sha256 cellar: :any,                 arm64_sequoia: "8f66df6c1ddc9fb0cbf0ad4f1293d2a7bacf3dde6917aaaf3d94df07d9487ca7"
    sha256 cellar: :any,                 arm64_sonoma:  "a5f2a519436bb3e66b643f550ac9554167e083623f3626259bb255e3d45e950f"
    sha256 cellar: :any,                 sonoma:        "c5b02d072461fe952a2e9967de9d314cb32b8522c4134047b62539f5f0a1af0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1322799f3f636d36ecf8b0e465b5e7864153af2bc61f951d9dfe334a8029d8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d91f0a5377ea0d82008171d063146a5ab6c42180a346d199bc9b3c53784a5c"
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
