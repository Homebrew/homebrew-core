class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.23.tar.gz"
  sha256 "4792c047ddf15ef29d55ba8e68a1a21e0cb7692d87ecdf7204419864582f280d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46163662cff0e3cb9c4358c73849d22080ab72928beaf52b3557f67f6b985a6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa06da82d08249d2e0db4a1293198a078bc580e374b81802724f45831e0e1958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "174810e3b1231739b79e446f2587fea14174ce8c8e6881497ed08fbc02997b0c"
    sha256 cellar: :any_skip_relocation, ventura:        "aba8468f8c8d1cb2ca90c1337256498b4f05cb43522d7df9c1f291f4af34ae86"
    sha256 cellar: :any_skip_relocation, monterey:       "b1401a8dfc54c0232aa17846ca0faef93c4a8dc9582ee48c125e64f89154c18b"
    sha256 cellar: :any_skip_relocation, big_sur:        "db2f8103042e39c5471c3dbe9600dc0c55aa1d2ad693a75849488864d3208eed"
    sha256 cellar: :any_skip_relocation, catalina:       "c347c85a891de174408618a9d2ba1ded61c4ff276a7072334a9bd4ef731aaf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb70d29539d6ae13b2a6638c79dbb5149eacec480557fc2f3567c4adfc228829"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
