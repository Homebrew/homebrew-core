class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.88.0.beta1/boost-1.88.0.beta1-b2-nodocs.tar.xz"
  sha256 "a137bc52f38273802ae6c12aaadc305a9e755a17773ce71bc03e214fb891361e"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171968ec74f288dbeafafbd6b9499260c9419949e744448f95b4cebcfff46190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ac1798a2a94eed7036d444894605317a8913124de7ce95b8c10df2a723e1d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5c7ae2f79c8ebc6f9e6132cddb866a03c97e04b5f0b671550d113d4602799db"
    sha256 cellar: :any_skip_relocation, sonoma:        "1171bb8e3d580f0338e57a3d352a9bcb088937550f3d0d9f7a0bc11211d33860"
    sha256 cellar: :any_skip_relocation, ventura:       "da4bd6cc7653a68f3568e673b5b6470d48e224b817d5b700f4ba480b6042ff02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c71c3f08406c560af9723a12a88af8ea7293418c5aa2b66b7cc9e3b7c54ab64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4050db4c0364d62a8476fb8f4294eaf577cfbd5445061cfdbc69eb1aed449e"
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
