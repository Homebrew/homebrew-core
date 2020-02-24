class Joshua < Formula
  desc "Statistical machine translation decoder"
  homepage "https://joshua.incubator.apache.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982" => :catalina
    sha256 "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982" => :mojave
    sha256 "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982" => :high_sierra
  end

  depends_on "openjdk"

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "test_OOV\n", pipe_output("#{bin}/joshua-decoder -v 0 -output-format %s -mark-oovs", "test")
  end
end
