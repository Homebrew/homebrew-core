class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.8",
      :revision => "717023b8b38c0f75687936272f81f274e4728f26"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "f25a754c280106c12f0c4e40c39a66109818b885f8de0b7b4ee051908c4e4494" => :high_sierra
    sha256 "5a198b8fd381ac35ef870f42cb7cf2a9b4ef4fe7ac3817b64f234ec8169fd570" => :sierra
    sha256 "38da888c0c7eb8671fe1c1e0a3f78793d0f074f811e5949e509785fd0f6b96d2" => :el_capitan
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
