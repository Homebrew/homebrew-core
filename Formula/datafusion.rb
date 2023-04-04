class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/21.1.0.tar.gz"
  sha256 "66c046f97102fe65b9155f261bd71f636ad9bcdb153c004c0d43c2fb4a4fab86"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33f27826e3a47b06bcf30ca0dd5c304ff109c96b397a586ab44a77293d19334c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "358877ee09496f4e271978ffeb3e37112d340fdc8bcf49517c02c47739ffbe4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66247379aef234d5febaaffce519597e8e69dd91e5ca0c19879f123987a88249"
    sha256 cellar: :any_skip_relocation, ventura:        "7bcdd56575258cb8636f7ad013dc7547239965191ac0b83e07b2f54901c46d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f30f04140ec53cc8af3fe0f29f443bdd91d8be666da731e5b297967e17efeb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fa9039ffab55ff9654c45d650cb220e3b7a4127c93a17d603297c0ddca1b69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb35449196b333371a499960faa96efc28ed388083a95a508ef10a455543ff4"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
