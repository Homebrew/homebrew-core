class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/1.2.tar.gz"
  sha256 "8f611b3f25e10fac1e67cf8b30fea4c1c02db7ab8c55d39402fe08caecb68a1a"
  head "https://github.com/LuRsT/hr.git"

  bottle :unneeded

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
