class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.bz2"
  sha256 "475d589d51a7f8b3ba2ba4eda022b170e562ca3b760ee922c146b6c65856ef39"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94358c7073feca948b1c65ba8d5f2f83f9f2d1faea94e71f26ea1bbf205a7f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c705ee1805c2b72cc152a2e17e2bd095b1621311d4df05e6264aa1f0ba4cb53d"
    sha256 cellar: :any_skip_relocation, monterey:       "a6b89f26b19cba2576beed6b14663dfdb994bc5723a305d7e26b40e401c8fa7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "61636de3949e7652cd497d380b39932b8853d35fd2736865eb52eea7ccda8a5a"
    sha256 cellar: :any_skip_relocation, catalina:       "aa980455feef4a55c85ee15552b5f3e49a1a7a8caacccb71f168da0fc847859d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e71b1847793712fa48aed2a4c45a2ecd013129d416c221e773696784d455f1f"
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
