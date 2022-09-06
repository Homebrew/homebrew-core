class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.bz2"
  sha256 "1e19565d82e43bc59209a168f5ac899d3ba471d55c7610c677d4ccf2c9c500c0"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2554f876bdc8e1855fdd363317ecac0cad44fe347d7fa5d29f4b0266262b560e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "143a1b99dc5026110ee64264382d9ff3ec6fdcb87dbfd51649b9d20f53547092"
    sha256 cellar: :any_skip_relocation, monterey:       "bab5e2f23f461f1643b1c841cd59cbc77ad06f0aabd4b362d28c1cb29fa696a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "67002735a12b9bc625aeb01fce3f7308a2c14548b587501df29be73fe3c7da33"
    sha256 cellar: :any_skip_relocation, catalina:       "453aebc4b61fbba898665ce83b95d298e3176c427df29199930f87d4996c756c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ebd56254dd815d37fcb539bbd160476628df6b67f6c2e4acd6eb019c49e726a"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
