class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "425f551c5ade725bb93e3e33840b1d16187a6f8ec47abfe4830deefc5b70b2f8"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e43c9134fa84323f309db86ef670f429948284299adb69b14ee10cd1c2d63d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c27c04e876592313c987b68060c6b73ad3942d6442447c783e78382f785f490"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5010a94669192d1439df4e3dc25e56e6d2049486b30d10875c2332c68a7a7c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "d384c29398bcfefb38943a22e757c6c4a223866e8f4b3e68a586e43eda1bf8b2"
    sha256 cellar: :any_skip_relocation, ventura:       "c6249662ee94ac50b4e6b5249ad9ea0c89c77fd81d9d273851c180c722f2921f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44cc41443e085fd41a39eeb3e3fba19540926c849095faa814d33c4d0c24b9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab0e9c78c87835ca32ec42de382338f5fd17d2b628590fa090448e3b2b2d538"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"plakar", "agent", "-foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output(bin/"plakar version")

    pid = fork do
      exec bin/"plakar", "agent", "-log", "/dev/stderr", "-foreground"
    end
    sleep 2 # Allow agent to start
    system bin/"plakar", "at", testpath/"plakar", "create", "-no-encryption"
    assert_path_exists testpath/"plakar"
    assert_match "Version: 1.0.0", shell_output(bin/"plakar at #{testpath}/plakar info")
  ensure
    Process.kill("HUP", pid)
  end
end
