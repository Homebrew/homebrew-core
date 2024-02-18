class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/35.0.0.tar.gz"
  sha256 "2bf0e5d2cfb7533e35f890ff918f4d7bef79aa8c3850d74d602eabd52296406e"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02c2349946957ccf45f8d90c9d19fb2951740ee4d443dab70ebe94b9b8b191c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f06668071b1aa1a34a119804fa010db938f07f7cd141f744c54c970a96da84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f35738a7498adc34f923b56c126104898fe36d0a46086cbb52e2b6efd19e6e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea9c7bbee0d60a5694a13d96e7b4f773d135df1d3f288dbe1c9dfcd9c9be1304"
    sha256 cellar: :any_skip_relocation, ventura:        "a9df30be4404f07add5138707865de3d2cff3a976e2392bb2b52f0361c73c603"
    sha256 cellar: :any_skip_relocation, monterey:       "2193103252d84222541b04febc3eaca10ab22a23bb6d3a463aac2d366b571177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a55f3eef7c53595506a99118690758c294889dfe93119fccd694df8f673cfd"
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
