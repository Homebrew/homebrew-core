class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.98.0.tar.gz"
  sha256 "63441857717021bc8b3ebd752aa03a7c954f5cec358fa96acbb3be5da8f69a79"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9c02409f9a3a9489c41d1be7cf7f2312825e6435f22262a8bc2111eb94a9c45"
    sha256 cellar: :any,                 arm64_sonoma:  "610d965e0335f83e780ddbf60c57160e5fc001ca4701e403b8065ed461e99bc5"
    sha256 cellar: :any,                 arm64_ventura: "40f2da28796e497a4e59331d152bcd517559c080dcf014d1cc748434330bd9e8"
    sha256 cellar: :any,                 sonoma:        "d02244f8d5f382337b38d47af150287c00832f76fc15940aced30339b1871b9b"
    sha256 cellar: :any,                 ventura:       "f04d7ac0f1fd6bbe3379fbf831e04d4a58568740e1c0e782e9b750543a5ac314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2feab32dd02afe565b1e7218616208831dedd86845b4243d95ab32d618885543"
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
