class Llama < Formula
  desc "Terminal file manager"
  homepage "https://github.com/antonmedv/llama"
  url "https://github.com/antonmedv/llama/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "fbe387c567d4be018c7b031a87c311d866fb892a306c8d0619e5ce800a466bb6"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"llama") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
