class Joshua < Formula
  desc "Statistical machine translation decoder"
  homepage "https://joshua.incubator.apache.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a72914bf2b7fc045e74110fbe593bd2b7a7620161d60b82032b1dac396067280" => :mojave
    sha256 "15cd2defc70734d455c6adda067193905e0debe97c21c551e364bb67a4e5157b" => :high_sierra
    sha256 "7b04fb7031b9f002a418eb7d674d2ceb05be0926c0a7d8abfea644be6d381df4" => :sierra
    sha256 "b649095ea4a944799fbc1ccd8425464b7d2711b0a149049b4d2d5e92d604c5ae" => :el_capitan
    sha256 "6ac9fb24f8b1bb70a32c72c8436b8ad43717cf83d65499cb011214061b6ce6ba" => :yosemite
    sha256 "176fa47a6a2722fb5b6bf1e2efba8da32bab6355f3d844424a817882ed7b3a8e" => :mavericks
  end

  depends_on :java

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"

    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    inreplace "#{bin}/joshua-decoder", "JOSHUA\=$(dirname $0)/..", "#JOSHUA\=$(dirname $0)/.."
    inreplace "#{bin}/decoder", "JOSHUA\=$(dirname $0)/..", "#JOSHUA\=$(dirname $0)/.."
  end

  test do
    assert_equal "test_OOV\n", pipe_output("#{libexec}/bin/joshua-decoder -v 0 -output-format %s -mark-oovs", "test")
  end
end
