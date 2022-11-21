class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.8.2.tar.gz"
  sha256 "e6bb5bcac18ad64070b70836750a0f3752cbe5fe31e9acd455a700ee57f3a799"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffd1861f4f095a27e4129f870d526029dec92ff3c4f131eb4f7530fdd4bc8ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "781296e2090865f203899e8696fe7f8be436d096f385bc248284f206d1b678be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df177e67efa93d00d574848f26710b3161712112e8b8849d32ced7d7bd586ac"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad03eacc8657c26d995a63e12d5dcb6ea00f03764af90a14278dabbe70d6799"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c1c5c80c9f86d16d76e54c072bba3cc6da95f15cadade9a19a82b7bfabaa4fb"
    sha256 cellar: :any_skip_relocation, catalina:       "db7a9e4163296cdd137e2a5d4529794fb49171faf423767413dd71244b461460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07242d0562918294bf1d41bdc35a4aaa7b6c10d361c18a7f0c5b3e489267c756"
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
