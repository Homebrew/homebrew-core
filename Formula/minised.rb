class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "https://www.exactcode.com/opensource/minised/"
  url "https://dl.exactcode.de/oss/minised/minised-1.15.tar.gz"
  sha256 "ada36a55b71d1f2eb61f2f3b95f112708ce51e69f601bf5ea5d7acb7c21b3481"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "64c474b8f3728b7593222b7218d5e5a1d17b9f1c33f4abb94eab2339a1398826" => :catalina
    sha256 "b43b719ac05f5c54e05d06941d1c2f69b960babef1772591e4fb16b3cf84a36c" => :mojave
    sha256 "e750f1dfe8ebc2f45837da1e20d1db531f896c5ce391250af45674c91b63f499" => :high_sierra
    sha256 "c0a44653ebb7cf8f795fbb96d126abf1f80d5b2bb38a2d8d998dee1b7997e019" => :sierra
    sha256 "4f33f6d39c9190899cf04857f70481ffd57996daf5001cad661ae0ea7f002a88" => :el_capitan
    sha256 "d169d87a77fe06c1190065e502e84fc3f3b3714cdc98a1235c78033a41e6a292" => :yosemite
    sha256 "505d4a7dcb7deeef34344f72b7c7801f90e2c38393add6e2bc41a6434c3fd899" => :mavericks
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
