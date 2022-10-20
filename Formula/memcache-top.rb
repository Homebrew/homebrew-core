class MemcacheTop < Formula
  desc "Grab real-time stats from memcache"
  homepage "https://code.google.com/archive/p/memcache-top/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcache-top/memcache-top-v0.6"
  sha256 "d5f896a9e46a92988b782e340416312cc480261ce8a5818db45ccd0da8a0f22a"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6599577907d4472abd334e62cbf3e718f2e8641af18d2c9a4b81aa77542929b"
  end

  def install
    bin.install "memcache-top-v#{version}" => "memcache-top"
  end
end
