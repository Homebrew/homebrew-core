class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "c0b8a85e92e216dbfeaf111cff60d685c83db6e652b3e2282c876451b5b50e1b"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b34329cb179a87c69a3fd915088c89e4e2082fa16b4f14a6dafc4cf76d7b15b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ad4e0f8ffc8c17042d03186f31c5c7b19b23a0c50e0f46baf50ecdfe774396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e5918cdbb4dfdcf379f8cb485c17d3fde190ceabc844db08a0c2da9f50f6e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "305114100197e2287026379e77ecf2f5e5208709f48e114bd906cca44b57e4cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e471ca4af62d507e210299cdbfd726ffc6bdb82b6c6c50be658820bc726a2cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4df157b3414778a4a4abf5ada095d4e93e152d3a113b5b265bb6c294d10d35"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

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
    config_prefix, log_prefix = if OS.mac?
      [testpath/"Library/Application Support/bookokrat", testpath/"Library/Caches/bookokrat"]
    else
      [testpath/".config/bookokrat", testpath/".local/state/bookokrat"]
    end
    system "ls", "-alR"
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
