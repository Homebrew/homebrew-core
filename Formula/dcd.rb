class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.5",
      :revision => "723a3ee113941742b310010d221b9dfb38206e42"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "076e01c8ee10a64799966c2d5ba644bccf4175348d8113acfd6c8cbdb9dffb18" => :high_sierra
    sha256 "87ab7a5143fdfe8ab210f58fe329a258071e54662253fd461cd12eece04df361" => :sierra
    sha256 "7c5d79dbec3a5daedd2f0c3a32206dac816326d9cdbf7b8fe34c17b1b06e572b" => :el_capitan
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
