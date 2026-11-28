class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "eb4cda4dd438ef69d2b7e96a922a29e01c9c24999c2f49eb3359a9ce8e9d90cd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "89ea53bbeddb61eaa4ecbaaec027d5a463f8e3964a572d4fab6153eb45132cf0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebce7f411901dcfb146d90c02a74d396cd649a3f008c6a0700801eb62518ef6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a201eb788ce445332735269627c1950a69dc7c28dea6adce25155d2ef2d86bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adb08806ce2016c6dccf3907d1cd75d58ede5d63767caaeea3439d79395fb1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4cce21c5c9b2502af29f7e1abe0619cc81a423c92233fa79c3e39d94fb8f3878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b14a3b0881a4aebc5ac453a51288f53ebfcbbcda7916883adfa3346a9a2a0f23"
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
