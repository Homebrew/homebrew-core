class OpenIn < Formula
  desc "The native client for the 'Open-In' Chrome & FireFox browser extensions"
  homepage "https://add0n.com/open-in.html"
  url "https://github.com/andy-portmen/native-client/releases/download/0.7.0/mac.zip"
  sha256 "e45e84f6876b6886f401f7660376140db53a7ee5fda962d5395161dcf148cb1e"

  def install
    system "./install.sh", "--custom-dir=#{prefix}"
  end

  test do
    Dir.chdir prefix
    system "node", "-e", "require('./com.add0n.node/host.js') && process.exit(0)"
  end
end
