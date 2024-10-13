class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.15.tar.gz"
  sha256 "0c6d60e837a9f94685581d815265a60a16331c0a3cb2d6fc5abfe1c97963160e"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cdb1084ff9d0f39536e63c6e9899d4d9103afc3410499cbabf7d2c031629be20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1144c287fedea8ba41a937b3637baa62b820215c82f1d781e11c59b8afbeaed6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39066c4c706ebc634848418c2d07921759ef031092a0250c3eb9ceb71b088770"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559394446325a340d1d026c9ed7d1f49aff91c4ccff62d73ff44eb01a51c65cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "96d3a1f00c5de835f4f70bd0db658bba4b4ee9dcea35669247d4fad87535b62b"
    sha256 cellar: :any_skip_relocation, ventura:        "9def15db47e02c7323745b201e122cd7a728052d3518e0690734b5c28caf9664"
    sha256 cellar: :any_skip_relocation, monterey:       "f074d1b2dd7f26e1dcdb93be668aa60761376878d0d7f8e1c8908ff812afc607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9afa54192a1290ff2e58863748ac050ed7d6777711f609ad0bf280ecf3033be9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
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
