class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://github.com/boostorg/bcp"
  url "https://github.com/boostorg/boost/releases/download/boost-1.89.0/boost-1.89.0-b2-nodocs.tar.xz"
  sha256 "875cc413afa6b86922b6df3b2ad23dec4511c8a741753e57c1129e7fa753d700"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96bb9f9ea9bce6c06ea76bdb499978bc8a1691f001300086bb6a701b7f08c527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059e29a6e5ea0282d89e00824f9168dbfdfdb2a9416a354ce1d7deadf1406537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77de405349c635ed203adda0209ccb2e10181119b276f7fff7d194adcab42e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83553dbc596a673f145c29f598e7eda0a44103de1e63faa23d4d0289a7ee8627"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d8d7f656803a4a414d3191eac351a6b2fee75b47b2e74ebb681e0fc3a525ab"
    sha256 cellar: :any_skip_relocation, ventura:       "f9adcbf91edc0f6201d5aa12c93e093ec1038b3ba91cab078503ea04c50f946e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174209b11a9b545d078176bcc3496419f1f1542f29f07e634a5d51646c6c3a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "616522539f98f8b39c4482feb06d59f1d6691254f715e4162013f8f2786d6799"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
