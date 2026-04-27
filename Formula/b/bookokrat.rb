class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "86cc446dce3c0a78de462ddce3434d052a6b0cc2c66e9ee4ffd5c0977f41441e"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a4aac4f52f18033eeafbb4359fac41139a31382f2132b65f2efe73ae699302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085ff7e3965f0f12e3898b38e4fffc56daf39527c212a01789d7052e8faec5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e13b69b7a3e9725674594d03e225bfbff5f6a012b571f60ade031d2fd42482"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef1b974633a1bedae5f7282e3c8d68bf4aa5d8a14ff99cc9cc2904617afc3f12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68f759dedf14ab05d1e56334a94958d6b7829a54d47033ebe0dc9d7aceeaa0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4676d222664c1a9c61717403a085c3edb47ea9259b8bf593e8264d23215fbd61"
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
