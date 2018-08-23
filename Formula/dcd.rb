class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.10",
      :revision => "5a73968870fc7b9ba76a76be1ae193c32d420b13"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "f7c3ab067e1c1153857d8916aba9b00cc04e2dfb8dfa231a198f2d1ad602acb4" => :mojave
    sha256 "739d4a82c6dbf4efe3adf9de486bef9365d559f505394f47820994259851cc26" => :high_sierra
    sha256 "53c121c43c821cd3c6afdca30488f91448b76e1d292961edcd1fe4c632a89a58" => :sierra
    sha256 "d6d1e661f523049d5bb6dde2008fbc9b2dccad64c847951f9aeb94ce30b27a97" => :el_capitan
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
