class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4bd07550057d1f199e52804c5ead1314c992091176a814d79acec7245602621e"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b36638ef7a7bb9b0b505e3dbb561895f65e19e2f68e0cc19a010e490a26f7fbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3c7eeca624c0800e54a2a582fbc3e2aeb62eca1d8cd913342d915767a13baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea44eee876fc064ebd2aee81b2941a71982f62a8503ca4ff12f30b6686d3fd00"
    sha256 cellar: :any_skip_relocation, sonoma:        "72394a3de2bd9901acfb071b357fac8cbadfdba63de803045d80b984040c6fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1582400866e44cd20e19afa08f333802d839bc14b29630f33b0e352d3b87828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6459e308a65c58e0dc5c15e1853fe33f229c65ec22793162ca24184cb4f413"
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
