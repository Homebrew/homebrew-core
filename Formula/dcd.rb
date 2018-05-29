class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.8",
      :revision => "717023b8b38c0f75687936272f81f274e4728f26"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "447d9794dcc22af4a17e6f7d61e140a42223cc0c93f172273bc06ae762d395bc" => :high_sierra
    sha256 "077b389e23dcda4aad0504177c788c258e03e63d792f1efefc28a4869abaabab" => :sierra
    sha256 "e81355bbcb79b661796c83f989c910d1dcdb4f637c190aee23a490f6b98b4aaa" => :el_capitan
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
