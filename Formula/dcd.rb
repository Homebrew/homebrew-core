class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.2",
      :revision => "d47d07aba8f07d053e104cf29f83fce60d8174a6"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "08cbfd6da2e2461e50c10f9229a1317485452115c0797860427c6bbe429c8dbc" => :high_sierra
    sha256 "4faa1f86772d366d9ee6858bb2cd5a777d1a21868074c0d9cab4ee4d56e55abb" => :sierra
    sha256 "17ed040b21aeffe43b2918b1a48cdcc7bbdd25b7c769e6c186292248ff21eecd" => :el_capitan
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
