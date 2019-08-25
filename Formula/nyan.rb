class Nyan < Formula
  desc "Colored cat command which supports syntax highlighting."
  homepage "https://github.com/toshimaru/nyan"
  version "0.3.0"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/toshimaru/nyan/releases/download/v0.3.0/nyan_Darwin_x86_64.tar.gz"
    sha256 "affb93aca8ddeed113118e3c08265c6fdb934c7994f362a2f9090ecdc4902828"
  elsif OS.linux?
    url "https://github.com/toshimaru/nyan/releases/download/v0.3.0/nyan_Linux_x86_64.tar.gz"
    sha256 "989eb26f0dc717fde5eae9f47da34cce235562a50adb1debcba7b23de72e5e11"
  end

  def install
    bin.install "nyan"
  end

  test do
    system "#{bin}/nyan -v"
  end
end
