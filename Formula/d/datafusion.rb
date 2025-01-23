class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/44.0.0.tar.gz"
  sha256 "f3afc14c735db37525db50cb71144d895e7b0729f696ff97439590759c13afa6"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f19a572ed16a7a279dc61b0cb2e391d20d29f94e40af2f1cf117d334af185421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810ee05733c7945380a87ce3504b52c066ee4d2625c10e5e320ee09ea223ca44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c7bd7633628893abf29ae7829a9a04754b98018ebba29622728633c72d7da94"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df78de31c02cee7d27787a22a657607481516df41ba20d35533b657f17388ab"
    sha256 cellar: :any_skip_relocation, ventura:       "34bea9512c5ecd959a1520c2dbbed4d2779f2d2c3d056f3a09b207e20d444490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d1e6cc01adc6dce40162f00b01b1c6e98d85fcee5d678ffe475b672c735cde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
