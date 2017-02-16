class Hide < Formula
  desc "clean up files and folders from the GUI"
  homepage "http://evancooper.tech"
  url "https://drive.google.com/uc?export=download&id=0B5Yw7X-K1mhfZ0szbDVZZUR2Zzg"
  version "1.0"
  sha256 "17566106a210dac640b0a672af4a7fea0eb69a1d49450c41e8e79f7b4d7a18bb"

  def install
    bin.install "hide"
    prefix.install "configure"
    prefix.install "CONFIG"
    prefix.install "INFO"
    man1.install "hide.1"
    system "ls", "-la"
    system "./configure", "initial"
  end

  test do
    system "#{bin}/hide"
  end
end
