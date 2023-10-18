class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/32.0.0.tar.gz"
  sha256 "c6e74d58b22d14fc0679eeb2e3680d88613f33b7880d207afd5c9341d3d9a5ca"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15a5a66ae6e1887a51732fdbaf561864d1f7314dbda5114288476884f24d96ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7249f81f4048fe65a812b4c058a567a2bbb142f12ded1e36ce7a76dfb6842cb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f76ecc959bb18363f72850d89754c12086965a4093385db3c63272762eaaba1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a07170069ae15f65a13248d861d3f9d8e94e00c9b90f3c6f526dba918efc936d"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9fad747e8f4bdefb019621da6c1303be8cae717dbf8ac852ccc1cf4c89a35a"
    sha256 cellar: :any_skip_relocation, monterey:       "06de44887360d7d65802283c32353a80a5c05a5cfc12670e89fa58d11d7f9bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e9c32e02421a75e6c522a17606943f4dff4d52fbf62ac92e81e847ab63a175a"
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
