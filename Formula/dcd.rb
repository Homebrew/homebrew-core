class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.7",
      :revision => "ff4474eb1bff9f2221b97062543b9b9516290c58"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "a1616c9d1271f3001b78f1fbab166eebeff644a330223be7ee43fba5e3ea007c" => :high_sierra
    sha256 "7c8b32f5fb86462789a145fadc568344df1af1730567c507fbab319b1097d094" => :sierra
    sha256 "8d74a821a8fa93f815e3715f27e8c2a6771c362b3a08097d16af05db28411225" => :el_capitan
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
