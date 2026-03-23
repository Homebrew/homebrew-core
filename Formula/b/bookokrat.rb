class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "9257c00ec69866c017264ae6ab3903c08a72372162a24ea5ccbb0b0bfbe68754"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56b48e13a60720ea835fa2b79c382676b46399edaf4943f3a0676ca793f68669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4982721595e58ae305deed194ecc6c2973bb86900346516582d1312c9c8eda9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd8097f9e5ab3bcb278c3564454a9ff3b64fdd58938679e613ea07bebee48be"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5937eac5305ea00494eb09b25c9105adc7829e765205849d651efacd9a0857a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be10702fab72b7a1793ee543dfaf21ef9e421fd928a3a2bcf201f606d1da831a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b3e021bff357f18f1b94417c5afd0abef9c36f1994ed45cdb8d19a2cd4c4a9"
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
