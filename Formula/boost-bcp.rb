class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  # Please add to synced_versions_formulae.json once version synced with boost
  url "https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.bz2"
  sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58fa7c3d18b6c5ac8a56475bbb315430e6f4581b39f3c6506879f4adfd8068e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "416173b54edea43357edb6fdd76cf2c89060015b889a9e1843e33e796b6a97c4"
    sha256 cellar: :any_skip_relocation, monterey:       "02213b90b218fb2f4d38940a59c3ae82e612405adc7e5cc79c296ea6521273a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc527cdb08563bbe1a03fd9d59085d3737ab197e753085e5b3d7c11704d7ca03"
    sha256 cellar: :any_skip_relocation, catalina:       "5fbf373c4fb07fead636165d863be6ba56f52c929926e6e301796a1f00fca3af"
    sha256 cellar: :any_skip_relocation, mojave:         "e483b259f0c9b6fb2fb1ff1256c3b3421d5f5c09a807819076200e114f40a0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa4af82624b089572d76ce463f5fc7c551bd53eeca67d4077e64bc104d28247"
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
