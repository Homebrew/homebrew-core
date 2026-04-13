class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "ea18285044f5c67585091c0c807caa7f8f154fdb97383d8ec53ec53f6bea29d7"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba4f49b43fd0400343169daae28629c5589cbe060a9ee64d53e2815286b4473c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "599db8be2885781416ede5947e94a07bba7176cff221601b9f54b2d2bfcf3a5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1584147cc4559b03b41b898eca92a9ceaabe547066feeb487172cf62fd4c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "528e2f2c5a6c68a18415f8194ad77bdefcf38d98d17ee6b022c91709360f9a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a94c53c1f0116e595eb9ac59c10abdbc0dd2ae39b245ada73721b7f08ce978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e914a3a9f96fb4961a5c43abf241702a9bc080c14823459e061ccfc2c7df7a5"
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
