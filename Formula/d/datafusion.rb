class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/38.0.0.tar.gz"
  sha256 "4e5e2f9fc13cd438ae766fd805a6482fea95f1ed9e41ebd2d2cfc07b1a77607c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "036703f93b3fd110c1421a2e86558ffe359da850cc4677a72be6bca788be3641"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6df9ed2693e89227cd7ae81b8f4e4145fde6075e239dc36f77c2a9987a163ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64beff7b0c46b3d55512bdaf52120b21ce440c9f079490724d3c84ca34e8656d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e94d8e01f98b72a0e16670aa2a3ed8384bbe9c539e5535b9c916574ec53bfb6"
    sha256 cellar: :any_skip_relocation, ventura:        "5a2f2092d32195cd1e42887f6d32cc6acf455daf381ab0a1f357dbeb49a3c0b5"
    sha256 cellar: :any_skip_relocation, monterey:       "2f72f0cffdf948025ba98b66a88442c652b55647653ee3492b4a66a29da46d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a1c79bc102d8d585851be03c36cc20506cfcbab9e743deb043e44ec25b3e59b"
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
