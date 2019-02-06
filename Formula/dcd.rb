class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag      => "v0.10.2",
      :revision => "a163e33beb69cc661d8f82b3d983b4f39955f312"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "a49897b2a0121373d7ebc89c00c7baa51ecf1b1a830055449099675b89044067" => :mojave
    sha256 "3317946c71ba93b79d6004a36cf4d1e29c6fefbc7bdbd53d32410c3f566528dc" => :high_sierra
    sha256 "2ca8ab9e734c5a1cd5008cec33fdbb322ff33a512a1d4bc6658e3796519e4fc8" => :sierra
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
