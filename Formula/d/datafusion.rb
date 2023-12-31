class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/34.0.0.tar.gz"
  sha256 "6788776c38b6f0593879e7c58268febcf802fbc266dd5bdd7695d66710df14e3"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14c25bbbd0a9e36ae033087dad5af3375ef426d9c9f4dafab4a2e9f1f4ee92c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab8dd123a09a797e6cca400bab1b2f0dcca301caf1a8eab0d8cc1e3e023d24f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8464ad37d02d59f76dd8159d1d439e792ae62790b1f311c71a18c6e6d99e0956"
    sha256 cellar: :any_skip_relocation, sonoma:         "42967ae9b680b700cd647935947a3a65effb706dfa097e71f340c906882a77f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4108d0d879c910d88419085c96b956754f34b0f359e9422a7b844ab5875d2e91"
    sha256 cellar: :any_skip_relocation, monterey:       "8344cde44dfba072e42c4c8d4f882dc2da3ea49b2211a0f44e5b94b332bbdfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4be537ac6497397e6f191a5fa7e1043c23bd95fbe2768203a22224ddb188b0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
