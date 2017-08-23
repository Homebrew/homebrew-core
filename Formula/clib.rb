class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.8.1.tar.gz"
  sha256 "f5718e316771571971cb4e5a0142f91b47c6bfe32997fd869fc5a90ec091a066"

  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45ee37757c387a106c8831ef40c8848d54077638ed52116bd8af1a95897b0a0a" => :sierra
    sha256 "932173c4c8f747c2650b3c7df1e5657cb21b86d19c70e659d90afea181ff26b9" => :el_capitan
    sha256 "3699ab855bf189b8a6dfbdc7d73eba4bf272807fb74e02d4f382a043ef66ac35" => :yosemite
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
