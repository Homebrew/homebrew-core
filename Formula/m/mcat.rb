class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "90404f223403e6fd561e55ccceb446bc08a83c848896f50e6c0132c961a4871c"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eaff9822cce6a3d2eece9659ebdab1db61863d6840b6778c5a9fba7a2d3b87d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d56a292002638eb00c183635606b6dc0287e3dafc0f848f7383334a42f92c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee205d9d40cf3af24e878dc768b364074e65cc31e1f6d3279ac7b6fd7b5397d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9647124e206f3143fb59ab4dc1ac4f6f978e502249a96f1db0cbec3b2a1c4cae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef442d974668b2ebd07baac680220d64b3ea4bd5e6ee735095f2d6920e91568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5263f5d6021e6facdc670a888f29c6b43f344d42fc23f5857218a7607aa4710d"
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
