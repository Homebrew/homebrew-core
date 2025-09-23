class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.104.0.tar.gz"
  sha256 "e009e08453fb469d0f6619e40fa506b6549070b623a3dee44a2694256245b67c"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53c0c2494cb20bf5a3f26df38bda0758330e6335e04d042af97ceab7675681a4"
    sha256 cellar: :any,                 arm64_sequoia: "fde382eafbd461ccb7123f5b2516dfde646f1adc69302a1cd0ddd20e668a082b"
    sha256 cellar: :any,                 arm64_sonoma:  "cb13bb2dee82caa9b6b1d49b8d185a9f9598089abf1c7197f8e9d4babcb5a99d"
    sha256 cellar: :any,                 arm64_ventura: "5ab05c93019a947c336c38f82909131f9e619a41cc962062553fb1ae796446b5"
    sha256 cellar: :any,                 sonoma:        "6a934e8f88db81dda5c97fe54886c8cf2fa27eeee872b2e6ed170e3a871a2274"
    sha256 cellar: :any,                 ventura:       "4c80cbc6a613667e83285548094b78899ae2d4ef27daea5dfabdc5c7bda8c517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bed6fb4048484600f4c45e6cb718d18e1d4c912290baca3e2cdc6a80a33701d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff0cad4afcd7c404cbdd1f9460466aceda644f67f259f6456b1f6a0837c88a4"
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
