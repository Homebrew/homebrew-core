class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/22.0.0.tar.gz"
  sha256 "640a56d1cb51bc9b370a3e61299b659921cc500fadc6f7201c05d5aab9249eba"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d99bbf000c5d2af7c6b4571ced98e46426f3bed47b94f339ca60a57f75c7a71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "600d7925214b6dcb603a4574563d1f4a59b1c8e2abc04212a77d0690da73724c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03083a66ebfffe7a4743860506ce4bec66e61ce2ff519141648122812c3b42b5"
    sha256 cellar: :any_skip_relocation, ventura:        "27b2843941eae166ad23a77c255163ebd2373d2c170948863bcd565a218702aa"
    sha256 cellar: :any_skip_relocation, monterey:       "046b08d2af1fe8aa8f6b157071be27f5d67d702d7d3cc7352acab54b8885ddf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "049fc498113b0750af6239f613b863ab526792e4f9f49b04007cc4092d294d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44d02e87ab6fd8c2d1a8769bbcdafbb6c2ce20956c43453ce889d49c48584ee8"
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
