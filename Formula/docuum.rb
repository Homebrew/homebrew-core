class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.20.2.tar.gz"
  sha256 "001eb166900b6dba89abc4ed76640455e98090bbca321fadc7811225830f336b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d31a9e6c05c8386800f6d318e926f03d8e451e6d86bd8c58adb1b1484fd4e0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5642aab3274b0bfb112c55f91e84004f9fae06196c85c11db299ba13ae25349c"
    sha256 cellar: :any_skip_relocation, catalina:      "3d3cc389fb68c4a90c8ab7276303a4ccf5aeeaa2aa25094450b49e50d750579e"
    sha256 cellar: :any_skip_relocation, mojave:        "0381a4f8be35a1bdf85af1cc10b5be22560ff44529b63bff32011d7362c78909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b45019f50f39d1888dff2134f1d2ffd69bef5fd42b5db33f2130e5850cb5998e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
