class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.1",
      :revision => "9f4c6ddaf43544682de37d864d33b52e9648ca10"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "02904b57ac4e20bc2cd006645314e865248a39ad7186e7e356a1228293c1ad10" => :high_sierra
    sha256 "721cfff4b43747b138373b86c8cfd373e75b645ec2177ba7581a4336ebbff137" => :sierra
    sha256 "bc1f17d29075c6535cae3d11c53962a967e3706048a620c0a3b27e28aa5eaa2c" => :el_capitan
    sha256 "47a7600d9a6f3a8e2fb386bb501640b47d0bd026eaefe51a5efae189efe2accb" => :yosemite
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
