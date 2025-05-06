class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.99.3.tar.gz"
  sha256 "81659cfc11d5c3a9a2ab46cd7e9a4d4ce4d4389a9e36cb8d1070503fc4e4ad3e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1361cd13fb647ee4a8197e0be26d88bac23db87d1ca603e87d9112cc0873744"
    sha256 cellar: :any,                 arm64_sonoma:  "c3d22103681387fb781c6e46a16ab560285e144f7078dd8358f490ca8497403b"
    sha256 cellar: :any,                 arm64_ventura: "13d5afde756f30bcc791b02e037a5606f34c7cb539087afa84666f61b4c7a398"
    sha256 cellar: :any,                 sonoma:        "21d972ed35b82eeee327f65c9c74e1f4ec29ffce8e9dffd50c5f98d4cdf65c93"
    sha256 cellar: :any,                 ventura:       "b4bc9809b4b60030cb41f674375e6ed6a69a3ae36f0b8be31c323ae670b7e5eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a439e257208f43576077bc52e2daf1de72931db24f40e6b0a66b4772a7369cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d63bf0568786cc3a21c5dc7f1304e7946ebb761a8af38a7a3d49cec0559063e3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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
