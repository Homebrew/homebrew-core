class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.4",
      :revision => "c90afe1ece9a7f5723acf284b59ab390f2b18a13"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "ef67572c271b275f3024850640cdb55ea5c34932c35ae917802a50c4b34250d3" => :high_sierra
    sha256 "c5eab62828d24813f3eee7e7930dabb493f4297c9a611530cecd08721b5b6a99" => :sierra
    sha256 "42f8eebffc6824ad487ae5613963b89d32111eee4d49fd8bc162e1d7d0be57ac" => :el_capitan
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
