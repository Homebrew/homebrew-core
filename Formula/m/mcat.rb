class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "c1a667ad4af9aea9fbaaa55aad81f71011723098b048e5c9520bf4246251959d"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afbdf73688afd1df1ec751e8b531f746c9639463ca72f6e898e7e9782762274b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba94d54c7d7651832ab261fce9352e0ea46aa9996f80c9980970053ae0d972cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206c7ceac04f663ab7c626b706489c496f1069ed0b792ba08705d15b0d7584c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4df058d5d15601d8ba74d3b280970c6d7f255066c7d3e5b5aefc0ffa4d04c086"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0cb32d673a294b6ed45ee305d340f0fa83b2df7774124c6af966d69f54f056b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac67c14bb5b80cb6a0e33c8487d39c5d507e2d475bf6f0c6699e25c0569ffd04"
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
