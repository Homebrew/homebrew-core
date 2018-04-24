class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.3",
      :revision => "15f5b119773a34cfe29f48bc0ff55c2d0255d33e"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "efb837c406cd727fe1d7ab7f39ee9cc5964a391ba49f455c44b8693039c5e000" => :high_sierra
    sha256 "1177bd6e079b9efbb91b54e49658fb5b8b19d5c868aa22ec6cb52f074f61e9d1" => :sierra
    sha256 "f845d8411b32f3abdfdbde86589725d447dfc78c740fc46651852d36c8f7494d" => :el_capitan
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
