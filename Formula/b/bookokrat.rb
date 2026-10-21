class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "8c69c25e25c00edfef40f845db2c36969f0333454c0cb6a91356454be82c38cd"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4b05cc529db11ce7273c6e414db52fbf99bfbeaf29425dce826bd2de3474373"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9bb541c783912364b51cd8cc757846e876345444eee8a25d56d6919648582874"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "347a7ff88656b215c3133f6a5b4687cd024011b8db340f26eae4f65e2757f50b"
    sha256 cellar: :any,                 arm64_linux:       "bf9bd4443c30bae93ac6c97fe2ae81ad23a8bd7e778c738c259a33313d93c58d"
    sha256 cellar: :any,                 x86_64_linux:      "b7468649e24f8869dfed7d176d4de41f3e5d9815bd6f5540cd6b9f88f1cd7fd1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

    log_prefix = if OS.mac?
      testpath/"Library/Caches/bookokrat"
    else
      testpath/".local/state/bookokrat"
    end

    assert_path_exists testpath/".config/bookokrat/config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
