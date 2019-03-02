class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksoftware/ohcount"
  url "https://github.com/blackducksoftware/ohcount/archive/4.0.0.tar.gz"
  sha256 "d71f69fd025f5bae58040988108f0d8d84f7204edda1247013cae555bfdae1b9"
  head "https://github.com/blackducksoftware/ohcount.git"

  bottle do
    cellar :any
    sha256 "dc7239bfaeebfb31a1a0ed7ae71dfdf178394e4f0842a74e457ec0e576e3683c" => :mojave
    sha256 "bf00398e44c1f2c1e2b9fa22614037ce203e3e196c7675dec4273e975837d8b4" => :high_sierra
    sha256 "15e8921a693b674c5ea24bc518a776b7b3ef80c207f9d2e1dd498248fce40f7a" => :sierra
    sha256 "2227295bd7e77ef3881186a3835718e8018738f8b443314ec16c2c7a5ceadea8" => :el_capitan
  end

  depends_on "gperf" => :build
  depends_on "libmagic"
  depends_on "pcre"
  depends_on "ragel"

  def install
    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    (testpath/"test.rb").write <<~EOS
      # comment
      puts
      puts
    EOS
    stats = shell_output("#{bin}/ohcount -i test.rb").lines.last
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end
