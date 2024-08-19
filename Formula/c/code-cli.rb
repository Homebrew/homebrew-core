class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.92.2.tar.gz"
  sha256 "628968d97ae66aa31253e649088e108813900d76fe2ce07d6c2e5312473158b8"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c4db84d2703b0be453950f270b8cb8b866e850735ca5ec36322fd0d1913122a"
    sha256 cellar: :any,                 arm64_ventura:  "694c122bbf8591b877c959178f2c1ed4b3fde01029ac0e57ef8b24a94b89ccbf"
    sha256 cellar: :any,                 arm64_monterey: "e9568201e55662d7449faf405e6f15f7566d19456706ce5692e89341c5353279"
    sha256 cellar: :any,                 sonoma:         "e95e7e44220d92b2bd078b2454fc3fea32633a6cb1811e8cf70a073629cf3916"
    sha256 cellar: :any,                 ventura:        "1b2b5820a1c9375838336353f12a7dd7892966684742d2633dd76f32b2f9b663"
    sha256 cellar: :any,                 monterey:       "11357f0e8218f9725859fa2010778e98cbdefbfa1f592ffa8fd4b7f458ca304c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fae3a64eed75ed798279fd11fdaa51070cc1a730441d3f3ba85a4bc4ec8955"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
