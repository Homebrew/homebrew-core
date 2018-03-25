class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.7.1.tar.gz"
  sha256 "986dd967b818ee044ed0568135db8be2083ad6c3995fe6281ada9b42b224a2ec"
  head "https://github.com/yonaskolb/Mint.git"

  depends_on :xcode

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mint"
  end
end
