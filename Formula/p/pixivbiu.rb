class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "3993bcb65abac9a0138adbc698faabd402fce84fbee0994307785cb2995e5827"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da4c1904ea28b89bfd400b02fd6ca1f8cb76c9fe289b8fd46bd3d5f442f758de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b2941685be38941473061d14ef67358591d339344fd3d040a726d4a6cb4156c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e8ecf0280f8897f1795e421cc77a635bd6ea64d9b9fe4418dd5eb1e38c7d446"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80b0470b7b0f8525e71b5eaf77817f23fc930b07339480c096527e4a084183d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "70ee5c94734459468394d816de13471b34b64db2f4c7f0f5cbbf28dc8d34e128"
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
