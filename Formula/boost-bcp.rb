class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa6a534d72f1dcc51cb69fe2fe1fe42a201da205dcb70f025255446f810e56a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "237fce500e3799cd93f53c5221448c915c9836a18b7b239dc19ec006e4291f80"
    sha256 cellar: :any_skip_relocation, catalina:      "2b679e21d034b4a68c4d1eeaaf6b4f8bbc6b5d456f396ef292009bdd874dda5b"
    sha256 cellar: :any_skip_relocation, mojave:        "78e095ee35b6a0821b1211d0a9e126b8dc62628531f6ed7180bcf3fc598550f1"
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
