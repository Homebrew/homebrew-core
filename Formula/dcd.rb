class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.0",
      :revision => "27a3f8a76346cb988473bfe67f4947db7dd7bc71"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "495bb87a467b94666178e4f4454ef96895bf2bf48a604efd7f1d6ecd43005971" => :sierra
    sha256 "8877d9cfc361eeb82ea73d328b61c73b66c3f7781e911790d143e5ef52bfd12c" => :el_capitan
    sha256 "78bc5c22508ba34d32c035f581cdb9bc09989fd6939c13a4f30a095aaa8fae20" => :yosemite
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
