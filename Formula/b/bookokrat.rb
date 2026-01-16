class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "24f68f902744138efb72f50388d96b95677b9455ce080263a5b5795ec1cd60d2"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bdc6772234dcb8d88e2329d21c9e32a3bd58474c5e7705c127083b75faf668f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1af06a6374f5b4dd1cda123d9228ab7eda6bfc203f89a3f839bb3aa5b8eae475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "007f02a9b5b079a6da0ba037babedee974ec21ec605cceabc89ddd4bc9a4bd9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9c357138bd6685122cd59eabe38f12f9e82a5ce425971838f2c9c3cf97a09c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2933ae278eab8399c4cc4cdeffcdff602b5a389759720989400ba6b0194eb115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d28f0ae83f56198f90e6815350f7af564d0842d2d71fcb43ddff24cd4a00ab3"
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
