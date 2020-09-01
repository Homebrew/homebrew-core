class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.2.0.tar.gz"
  sha256 "f0afbfefa474508263b991e44939d04828a02c8cf28745f400bbe18bd240bf03"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fd29b216886e47f1868b9ab39e42d516f51a513afc5b780c8f9e4899f459aa59" => :catalina
    sha256 "662ea4a128da3773ede79b8d2f9f4b77fdd5ace072d451d30c2181063ae250ff" => :mojave
    sha256 "9259cafa9e7e5171e1cd49bb165741f7fb7aad4e4471faaa517fcd6402a9fe97" => :high_sierra
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
