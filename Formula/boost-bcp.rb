class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf348b4c85bb27b40dc95fb19f63aa8963ef93734b722fb6712bd413ca590af9"
    sha256 cellar: :any_skip_relocation, big_sur:       "16fbea4de8f872bac006d526c2bac139b04d0f1bf72741902c7f78825f8945a6"
    sha256 cellar: :any_skip_relocation, catalina:      "8dcc84a022e19a58ac5c7b3ab161cfc544c33607b81de0a0c80037d1f1050081"
    sha256 cellar: :any_skip_relocation, mojave:        "e592d4d8ef2d288683c39193ccdb35e9ef451f5217b7089c21ad7dae012f2084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb100da3b36a96b90c2b73d59885e0c5701004caccea8478d40d33563a67999"
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
