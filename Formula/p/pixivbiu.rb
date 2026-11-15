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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8687012e2a773c20c37fee1a7110205aed05d663b3d92f6988150d46fdfca9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "623caa67051af368fa0ca40160aaf9e183e3246e2b1cdbb0019536ffbf0ce95d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "217334546aa4ebeed7510527492eb35547107cdc8d80bdaf630447a87f0f9d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d6a6c07c16b76dd0c7c3abcf4080c3b20a1a859e1620dccbde7e8a1336238b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4bdef2ac350d13ac7b24baa21fd8e93914113ba3eaac6249b50ba635ceca2056"
  end

  depends_on "bun" => :build
  depends_on "go" => :build

  # `test do` block queries the health API of a local pixivbiu server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "frontend" do
      system "bun", "install", "--frozen-lockfile"
    end
  end

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
