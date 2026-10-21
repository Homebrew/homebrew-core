class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "7d563a710921ac38bebd09d8c9e722b26ddeff42b449026bd6bacce835bd164b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea8f24a573df76ee04dddb2d19b37b7b8b58e651e910d54e6e22050a05528ba0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c050c4da900cf52160b69210e611fc2ac2a0863831832db6026bc0cd3ff02fe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a493ad468051c5c33086d05d499e1b6a94cb5109f1b868ce76159675ce140c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ff4af8a315f159411a8cd68ff6e024be1fbc428870e75b97b21686154e36974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1aed6d9a0f13d84c18c5083defa405b2bf03980753d6c1986f972f75a78c6e76"
  end

  depends_on "bun" => :build
  depends_on "go" => :build

  def install
    system "make", "dist", "VERSION=#{version}"
    bin.install "bin/pixivbiu"
  end

  test do
    port = free_port
    data_dir = testpath/"data"
    data_dir.mkdir
    ENV["PIXIVBIU_DATA_DIR"] = data_dir
    ENV["PIXIVBIU_SERVER_PORT"] = port.to_s

    pid = spawn bin/"pixivbiu", "open=false"
    assert_match '"status":"ok"', shell_output("curl -fsS --retry 10 --retry-connrefused --retry-delay 1 'http://127.0.0.1:#{port}/api/v1/health'")
  ensure
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
