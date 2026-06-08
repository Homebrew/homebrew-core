class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.123.tar.gz"
  sha256 "ba80ea47164e5860869a9aaa9af9bbeb22fc5264d0ae8657f7e5f61b8c1d8693"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a90fa81c2faaf4ee94f2910cb2aa364b970e31bc1113f3287c089c4fd928a8d"
    sha256 cellar: :any, arm64_sequoia: "54f8088933054f82338758462b2170b15e94139d77c3b2b0fd6d2c5c58338824"
    sha256 cellar: :any, arm64_sonoma:  "cd6840bf0eb80695dd44f4c21a147713871b81d606fe158fbcedfe96a54c169a"
    sha256 cellar: :any, sonoma:        "1f48f7c0381f1b48ba3d68886098789f9303732cb3dd33352c84a11d0a4e6394"
    sha256 cellar: :any, arm64_linux:   "5780c5db1b9625ea4a9e35a7fa936cc087af94658c3e014e298ca96ed47bab11"
    sha256 cellar: :any, x86_64_linux:  "22ccf16c30058e869da64086058d883d864952bf02575a36d26151cd0898b665"
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
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
