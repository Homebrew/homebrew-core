class Joshua < Formula
  desc "Statistical machine translation decoder"
  homepage "https://cwiki.apache.org/confluence/display/JOSHUA/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?joshua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9a3dcdc2356e269c23318dd304ec54fa172306d100b274c04a7e78440573987"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e37238c958548a5f28c843f65e9f9a6e9eede05d9f9b9a8e802fabae5e42906"
    sha256 cellar: :any_skip_relocation, catalina:      "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982"
    sha256 cellar: :any_skip_relocation, mojave:        "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982"
    sha256 cellar: :any_skip_relocation, high_sierra:   "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d89eaec2a6bcd8de99e07c2a1e77eee4d1e9d3c21239727beb1ab0f73173ea8c"
  end

  depends_on "openjdk"

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "test_OOV\n", pipe_output("#{bin}/joshua-decoder -v 0 -output-format %s -mark-oovs", "test")
  end
end
