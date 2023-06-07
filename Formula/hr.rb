class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/1.4.tar.gz"
  sha256 "decaf6e09473cb5792ba606f761786d8dce3587a820c8937a74b38b1bf5d80fb"
  license "MIT"
  head "https://github.com/LuRsT/hr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d71a3a75027a3bc096f492ed779d0603542382f936572d91cd3f1c194abe48b"
  end

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
