class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20180628.tgz"
  sha256 "7b84f63072589e9b03bb3e99e01ef344bb37793b76ad1cbb7b11f05000d64844"

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    #require "pty"
    #(testpath/"input").write("#end {bye}\n")
    #PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      #assert_match "foobar", r.read
    #end
    ENV["TERM"] = "xterm"
    system "#{bin}/luit", "-encoding", "GBK", "echo", "foobar"
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"luit", "-encoding", "GBK", "echo", "foobar"
  end
end
