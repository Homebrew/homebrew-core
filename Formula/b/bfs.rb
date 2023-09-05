class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/3.0.1.tar.gz"
  sha256 "a38bb704201ed29f4e0b989fb2ab3791ca51c3eff90acfc31fff424579bbf962"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "367342e005ccaa8c3a575ec567ffd8dda530f9ced0b13f2a796297178d3def47"
    sha256 cellar: :any,                 arm64_monterey: "dcf63dc3886001cdb6caf9c97369751cc2b26e805d2dddd31622b82c5ffaa35b"
    sha256 cellar: :any,                 arm64_big_sur:  "33ca6d4da0ab1a292b5370449545afa81f02106ff2764c49aab632bc20d242b7"
    sha256 cellar: :any,                 ventura:        "a3e74b2597fce21e2e36e787214b3d9832c22db22c58d3987b718436d9bae564"
    sha256 cellar: :any,                 monterey:       "29d42f0e8b5acc752998bf9e2b89fbe6ac8f3ef9b4b6941cf6c1e0dead449a85"
    sha256 cellar: :any,                 big_sur:        "ab33de3d13063eb59c205d1e7ef2579020f5024bd71e17e2258b55d87e581ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1c9c28b895956c0f81272ad5ab9c73bc93999fde4d7fa987f889f4250163123"
  end

  depends_on "oniguruma"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
