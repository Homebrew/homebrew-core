class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.11.tar.gz"
  sha256 "61d2758921c4911b0230fd99c175f29127dfc713a23462ed48bb89857fadd7ff"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "189360131513db9b2d69fb676d24edbb1a759aae0aabdb415b583a080fc991c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8b5977cbb9c9282207bef0d5e9449e282e5985cf38c40b481c28db455ee1ecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "314877bdf567abca90b5009dc8601d0e3b4d48d1094fedb4a8a43a13e44b9a06"
    sha256 cellar: :any_skip_relocation, sonoma:         "deb6e0b1f6317708f528b8ff33e5d080cff16f309c7d9e95481bee671b79bcea"
    sha256 cellar: :any_skip_relocation, ventura:        "f533985f4a936b989aee6cbf665f32144121905739dd35937da289cefe56958e"
    sha256 cellar: :any_skip_relocation, monterey:       "651b622f9ef686f16624d94ac0f7a43af318b75b0c64afd1c360d01b08b294f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349f7a384c9d0e326a853b1495dbb3696bfb1141d4ddd4587757e7e298118510"
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
