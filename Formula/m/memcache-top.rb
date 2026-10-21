class MemcacheTop < Formula
  desc "Grab real-time stats from memcache"
  homepage "https://code.google.com/archive/p/memcache-top/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcache-top/memcache-top-v0.6"
  sha256 "d5f896a9e46a92988b782e340416312cc480261ce8a5818db45ccd0da8a0f22a"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2ea3d9e19842c495db8dfe35711495867fbd1f3745558f4d6e93c1dbde3d35a9"
  end

  allow_network_access! :test

  def install
    bin.install "memcache-top-v#{version}" => "memcache-top"
  end

  test do
    pid = spawn bin/"memcache-top", "--instances=127.0.0.1:#{free_port}", "--port=#{free_port}"
    sleep 10
    assert_nil Process.wait(pid, Process::WNOHANG), "memcache-top exited early"
    Process.kill "TERM", pid
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
