class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "022adad76674d5a0cf9a7c1a23be9d6b608bf0847bdceee58023f8ea888b796c"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cbdac1912123da29b598815202d522b22904fe276f52b620ea363b663daf92a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62c2ee0f08fab77a659c5b735470ccd20e22a81ea2e1effc7fb2b2a17359a8b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2bfbeb90acf52960ef0544d8b273a8c8685ad5719cd850b593a1b0fdee16aba"
    sha256 cellar: :any,                 arm64_linux:       "a42bb517a9e2d24ed146d9c4496e1a04c23c40cc7cb1751f30fbf803bc5f8eb4"
    sha256 cellar: :any,                 x86_64_linux:      "4991b70a48a71dd9aeab8633964580083c81972852db53b147188fa7b719cdc0"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
