class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "0751669309b657aacf5bb22577d9b42d07e9f70b92aada2e717df189aeb1e72e"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a93189b784ffebccba8fbe79b6b40736a14e49a2b18a0759e2efc9846b8b33f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866dd0479606077d091b48d989800f12dc3df1aaf4819f2cb0d7551068f99817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d734863954f6146e73e41cba60025bc929dd1e85866d4ac944f56f88922a20f"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c52a8396099f61a9f869c317ff06dd88e9d99f8adb42d6f77cd58523af6281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e3135be6170aeb21c0ff37fc699850fdb108cbdc07287bacc2cbca33768c3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00341326706aef3aa1cdd778b024e6129a32b69dcdba709866c969863f895d21"
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
