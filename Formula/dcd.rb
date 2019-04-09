class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag      => "v0.11.0",
      :revision => "8a7a6c75acfb320e0b8aa5e00d210f5393ae3363"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "13b8e41055d50cebc054cb3c3be9a83f4957c655cc6b87567c2fe97c42cb3641" => :mojave
    sha256 "e19e1b335cf1f87ac7b969d01a87c4fcc0c0565cba4357cebbcdaa4e3646a64f" => :high_sierra
    sha256 "dfb6b5d7a1ac63b64d5d702132fbd3953ccacaa4b0554234a11efa80ec6f79d3" => :sierra
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
