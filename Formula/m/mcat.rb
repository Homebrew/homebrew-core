class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "505e84c3fe034921f81a224490206f3e329773d4264286a1ea0d53f95a6a248d"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bed50a35165364ef52195d033a8a6218ad14aa30850bae620260953e6d5802b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae74f8f3a7636a8ec05f21c0c535e39497e282790c563d2939e0420466e8164f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d365d85d1066aa3fc1dc26bf564463dbc9ec76f98e4b434347124dff72a7232"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed8b5e7a6e860f1bc7b577e006a6575d7fb1273f0b7e9bbe52da15a50a1f08d4"
    sha256 cellar: :any,                 arm64_linux:   "4f5f7b243f2a5e3a698c527224092dd2ba44a705a16f79881ec6d39e6bf922db"
    sha256 cellar: :any,                 x86_64_linux:  "39d04b97629ae70e02c94ca2e9f598e267a5f6b9926d5f059e6a2136d63ea3c6"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
