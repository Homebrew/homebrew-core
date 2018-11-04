class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag      => "v0.9.13",
      :revision => "baddc0a3fe97521e0b7fdbc1a45bde18afed4314"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "7d4f107a95d461b88545bb23a0c773f23291f10a82401d749caeb50347438ab1" => :mojave
    sha256 "93c5b0c23def8f15e0a0fa326db8cfd90d6604e0b3f5ee8c1ff7ff7e28e4ef85" => :high_sierra
    sha256 "01efe880d58d23cc46f03e7907ad933cbe746400ec08ded499d19f7059350ef7" => :sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    begin
      # spawn a server, using a non-default port to avoid
      # clashes with pre-existing dcd-server instances
      server = fork do
        exec "#{bin}/dcd-server", "-p9167"
      end
      # Give it generous time to load
      sleep 0.5
      # query the server from a client
      system "#{bin}/dcd-client", "-q", "-p9167"
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
