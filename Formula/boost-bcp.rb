class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.bz2"
  sha256 "71feeed900fbccca04a3b4f2f84a7c217186f28a940ed8b7ed4725986baf99fa"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f5b9d2eb8871f16281c40dc76f6f1de06a70df61197bbd940be344fd6238f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2b79548f3c2fc7d0325bc52cfc3f2ea0ea8112473053796f4acbce8d3c7f05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62e51f3628c119b86b55001f229501378e8e0eb163ac4d7a2af37d17af22647e"
    sha256 cellar: :any_skip_relocation, ventura:        "01b7a93e776c70aef0d53263ce253f38e2a48a9962da92e8cfda5f131c5035c2"
    sha256 cellar: :any_skip_relocation, monterey:       "e9570d39b41564c3ee0c2ff2b84c2115267425fec9398ecb25f8501e3a661c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "abe3f37d5335d4076b86f3920d5f98ae8aa5aaac8c04fe241f8ee7eac371cea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa890a7502ce06488b2ab8fb1746fe52396813e86eacbcdfb55dd66c0f9f9fcc"
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
