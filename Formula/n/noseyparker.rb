class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker.git",
      tag:      "v0.17.0",
      revision: "41f30e2ca0186435ed3649e220549d4a4516109f"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5d06c0d92862dcf8e88acf3a141a2b3f1b827334b103cb7ea6b7fb0e70a016"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b0500c41c8dc69cbc9d65aa8bda8b480ed5a777fc630037763d7e8027943309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8475de78661a784dea6b9fac97f0e57b2307b175b13e3c728629a0630da2b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9ef38987d3313d3772a25ba8492260b592ce9fa57697e66cb55c2f59b3026f5"
    sha256 cellar: :any_skip_relocation, ventura:        "89d5aa10e33bceba1a07d38d5e7600d382c293ac67acca0c488023bd87ecfb7e"
    sha256 cellar: :any_skip_relocation, monterey:       "d6270739d4c971d09ee74c48103f76adb8050836cc0a092e6c73d2c6253054d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b07cb6341ff98dcedbe9a57795c5b9bb61db9fe3bb136c427d18244d6f85a1ec"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/Homebrew/brew")
    assert_match "0/0 new matches", output
  end
end
