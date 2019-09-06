class Joshua < Formula
  desc "Statistical machine translation decoder"
  homepage "https://joshua.incubator.apache.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "17fe13d1fe356578c025aa681f16b6d5f929a986a6f102811332a75bbfdf3d64" => :mojave
    sha256 "17fe13d1fe356578c025aa681f16b6d5f929a986a6f102811332a75bbfdf3d64" => :high_sierra
    sha256 "343ffcd545e812b27b73807070f778e311d62011351be532de355fb85a8e7ed4" => :sierra
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
