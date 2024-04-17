class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/37.0.0.tar.gz"
  sha256 "dd9f93477e2d725ea752888b78c0c6eb0b487eb2fbfa56585cd78461a26577c4"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05128c0882d62b57fe77f0615fd37a24f3ec13f84a338c3f0c445c6202375712"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea2d547aace542d1ffdbd38f89d21b02210878a748a4331be0ac2196908e72bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92b5ab9a1a55c112db04a8256509ca6164c14b1ead7f00654796dfbd1e80ece2"
    sha256 cellar: :any_skip_relocation, sonoma:         "907b9249888fee7c32e5a69a411884f032eba76ec2b8b8ae419f5abcb7f79a28"
    sha256 cellar: :any_skip_relocation, ventura:        "c69016b3f105f88296eda1f0432ab4ad59e3714a1d2b554d0d93b80d815a7997"
    sha256 cellar: :any_skip_relocation, monterey:       "a6f929138852da3f6fc2a8c76c4d14f8b83b6e6932bba6bbeb4ccbe02c67c4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd1d25819f8ef2148989fa2031b5a265546316bdec159666256f1a81114b964"
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
