class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.1.11.tar.gz"
  sha256 "93c019b020d120f829e443a728dfc6b698c7679c2ad7099aa9ccae2bef18b4ed"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38c115ef5a3d0710c5d52f30933b267050218ae291a5dc9b09d8c45278f8b0d4" => :catalina
    sha256 "57efdde04a4718f75ba92b0e39b500af15c6cabe73e52a7dc690bab1280dca90" => :mojave
    sha256 "290d73a4136c505f0ff8935634a7a55243f7aa51685a6899ab9a4065b5012302" => :high_sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
