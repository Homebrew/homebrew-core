class Hide < Formula
  desc "clean up files and folders from the GUI"
  homepage "http://evancooper.tech"
  url "https://drive.google.com/uc?export=download&id=0B5Yw7X-K1mhfZ0szbDVZZUR2Zzg"
  version "1.0"
  sha256 "59a7861f9aa0dfce447186d8a03d4068fa544cf0031e87471a4b578862b04495"

  def install
    bin.install "hide"
    prefix.install "configure"
    prefix.install "CONFIG"
    prefix.install "INFO"
    man1.install "hide.1"
    system "#{prefix}/configure", "initial"
  end

  test do
    system "#{bin}/hide"
  end
end
