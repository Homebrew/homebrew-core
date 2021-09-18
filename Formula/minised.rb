class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "https://www.exactcode.com/opensource/minised/"
  url "https://dl.exactcode.de/oss/minised/minised-1.15.tar.gz"
  sha256 "ada36a55b71d1f2eb61f2f3b95f112708ce51e69f601bf5ea5d7acb7c21b3481"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?minised[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b2fc7359f26228e633280c4c4629564e707f0c9c66f3cc76afd8faee0ec915a"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd2197173a324322c8081c7e603d7e7fd243906399bb93cac50abddbc9670960"
    sha256 cellar: :any_skip_relocation, catalina:      "64c474b8f3728b7593222b7218d5e5a1d17b9f1c33f4abb94eab2339a1398826"
    sha256 cellar: :any_skip_relocation, mojave:        "b43b719ac05f5c54e05d06941d1c2f69b960babef1772591e4fb16b3cf84a36c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e750f1dfe8ebc2f45837da1e20d1db531f896c5ce391250af45674c91b63f499"
    sha256 cellar: :any_skip_relocation, sierra:        "c0a44653ebb7cf8f795fbb96d126abf1f80d5b2bb38a2d8d998dee1b7997e019"
    sha256 cellar: :any_skip_relocation, el_capitan:    "4f33f6d39c9190899cf04857f70481ffd57996daf5001cad661ae0ea7f002a88"
    sha256 cellar: :any_skip_relocation, yosemite:      "d169d87a77fe06c1190065e502e84fc3f3b3714cdc98a1235c78033a41e6a292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a0dc9b6a43648ee0e86dc5f16a3754e2d83639b6d7d58166b6b525df2acbeb"
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end
