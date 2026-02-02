class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8b25e29b9ac5d9fba29b96e3ac733c4d0798dd0e7be8bb9826842fd34855b587"
  license "GPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a24a167728755f0a36296a13fa622a2927fe87883cd7d3f3247272b6546ff56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb5cd3d90bf132b240fe8f6bde8b0f9ce85a5c4842ace9456fd18918f3dd3ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f360908027023e1d513100cf606d30f5ba88746f06638ca17dbaaec43ea1ac7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "751665b8423de2a0479b766e9fda01ed8b6ca7c2326d572acc9ab3bca1f12735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8345c004217255d01de708ed819f061d54337410e25b417abf7bb9ccb777214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1379eccb4b228e79774fd0306483bcaa2ef5092d67b649f793056e1449963eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath

    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/bookokrat"
    else
      testpath/".config/bookokrat"
    end
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
