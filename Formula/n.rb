class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.7.0.tar.gz"
  sha256 "92e00fa86d1c4e8dc6ca8df7e75fc93afe8f71949890ef67c40555df4efc4abe"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbd70d6eeb53d38588d27d22ee4e3b6f05129dc7f97bc0449f52113c0a12b1b4" => :catalina
    sha256 "dbd70d6eeb53d38588d27d22ee4e3b6f05129dc7f97bc0449f52113c0a12b1b4" => :mojave
    sha256 "dbd70d6eeb53d38588d27d22ee4e3b6f05129dc7f97bc0449f52113c0a12b1b4" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
