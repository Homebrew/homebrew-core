class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.8.0.tar.gz"
  sha256 "18d7a2f985f012b2a0ae05a41f473148625c5dcb9d0499b00a5312974e7dc4de"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcdff4f8b41c5331ebcf92739ad6cbd4a8396bf9011eb6eda656250f63d856f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1928de9d9986e8e0b581aafd54a23844ab321c547920e8d3b3666f77f58a5935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3753573197ac9a5c0122aaa5af8772021f648199b357115aceab19abf3072323"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c421edb9fb9bdd71f6354f65759c43f8fb03718195f38d74432f3ade866116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043d0e5269960c9ff5a9203d12270b2d486deeaacfe229c8c0172b1ae198890a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe3e856e81effd71b73c369dfd150e76b1cff882f1b39e6c7214b9df98872a8"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/envelope.1.md", "-o", "envelope.1"
    man1.install "envelope.1"
  end

  test do
    assert_equal "envelope #{version}", shell_output("#{bin}/envelope --version").strip

    assert_match "error: envelope is not initialized",
      shell_output("#{bin}/envelope list --sort date 2>&1", 1)

    system bin/"envelope", "init"
    system bin/"envelope", "add", "dev", "var1", "test1"
    system bin/"envelope", "add", "dev", "var2", "test2"
    system bin/"envelope", "add", "prod", "var1", "test1"
    system bin/"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}/envelope list --sort date")
  end
end
