class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/1.3.tar.gz"
  sha256 "258ff3121369d17c5c70fa18e466ac01cdb4cf890c605f7a5e706d5b1a3afebf"
  license "MIT"
  head "https://github.com/LuRsT/hr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01e0e362b30cb5eb92751375426626c3eb8d6bfd05aa61d3cbba188a12bd1b92"
  end

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
