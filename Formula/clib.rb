class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.1.13.tar.gz"
  sha256 "744b5e88d4c9cf9ed31b69c141b66b250ec710852480cb3f7f9a9f13f760f31f"
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
