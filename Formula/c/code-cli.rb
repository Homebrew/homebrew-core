class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.145.2.tar.gz"
  sha256 "8b5d5b049af4b7d145a69b4f2e06fa744d58f00c9ab33ab03338e273352dacf4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76a52d6649548591cc8952e933e7a2526b458406e8ff936346044ba3a518cb84"
    sha256 cellar: :any, arm64_tahoe:       "50931935dbef886163891333723a45f46db193eda8382227e8be9891d2dab558"
    sha256 cellar: :any, arm64_sequoia:     "962c4b03d28e3751538670abc745ee0b9e9d346359245f1ae82c16b14a8c11fd"
    sha256 cellar: :any, arm64_linux:       "0647e8082daf8285f7e9c1f3a07c130950ea3f03f84f32dbc016cbf5f8c1d426"
    sha256 cellar: :any, x86_64_linux:      "5b39f777efe61dee7d6bdb1c6cac758593e421a00db6f024e0e77d23964715a8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    cd "cli" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"

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
      formula_opt_lib(openssl)/shared_library("libssl"),
      formula_opt_lib(openssl)/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
