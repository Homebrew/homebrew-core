class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.20.tar.gz"
  sha256 "df5edf3e8cd8ec3ce0cf59ee48590d2f0ccad1ed6fb68ce16caf31a21983160a"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d077e8fec77e684c25528f6b016b1808a402fc1b54b3a5fb60cc5fe5ff2002a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7116bbfd15368f6f0a329ab9f970b1373abdd9cbedc97c7f93729ac8cbcaa36c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74cf64b8f48cb1ecf305b8237ba00782a3faf31d1d70a1dafd4f2af5b68ce817"
    sha256 cellar: :any_skip_relocation, sonoma:        "c69ece693c39c0de3bfe6e5e26d112ec66b1f655d6b58e6218831b04ac35a0f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00dac9d3c0cec491f497f4e81c8ebe0f626d4889383f10fa3b3cf0ffeee329ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266e148d4fbcd8c9c6ee3e379ee8b7c030c8d671f4a9dda2633459a1cac74c1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    generate_completions_from_executable(bin/"hwatch", "--completion")
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
