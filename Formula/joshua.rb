class Joshua < Formula
  desc "Statistical machine translation decoder"
  homepage "https://cwiki.apache.org/confluence/display/JOSHUA/"
  url "https://www.cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11700736da72d86af2c07f05365c1a52a9851ef62aa3f4b6ddaaef914ca4b03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9a3dcdc2356e269c23318dd304ec54fa172306d100b274c04a7e78440573987"
    sha256 cellar: :any_skip_relocation, monterey:       "14bc7441b66d9236c03273b5dc37a97373c5a80b3723e78936b7acf04e6c867a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e37238c958548a5f28c843f65e9f9a6e9eede05d9f9b9a8e802fabae5e42906"
    sha256 cellar: :any_skip_relocation, catalina:       "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982"
    sha256 cellar: :any_skip_relocation, mojave:         "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982"
    sha256 cellar: :any_skip_relocation, high_sierra:    "126f37758cb9f1ace827883911906cab4976bf5f211b200ed0e2f307fae87982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89eaec2a6bcd8de99e07c2a1e77eee4d1e9d3c21239727beb1ab0f73173ea8c"
  end

  # Moved into the Attic in 2021-11: https://attic.apache.org/projects/joshua.html
  deprecate! date: "2022-06-05", because: :deprecated_upstream

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
