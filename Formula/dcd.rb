class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.10",
      :revision => "5a73968870fc7b9ba76a76be1ae193c32d420b13"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "a8220c4378f6c6fe337b0b51ff2c9a62354ccd5b9cb18bb277781ed5d9aea0fd" => :high_sierra
    sha256 "ed5398c683e2e046956c90aea76352296c71b4557799fa822a36bfb121cbff2c" => :sierra
    sha256 "1da8fba35410b7306f5e4ca4a642de51802c3f8e35fd35128044df0f674669a1" => :el_capitan
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
