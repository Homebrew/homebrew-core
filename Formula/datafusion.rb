class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/17.0.0.tar.gz"
  sha256 "8a1e92587129793e90be5c97690eeb14e78979b9c75908e8e1d1b79401736e1b"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b5d79926da88b128e7a90e3ffacf369dcd0af128b361dce6eb34bec50ba928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6403ea1b252784f2bf441a0ea6e8e25ab195bdf9045cd03b5fe28adcbf2557f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f849a52f6aad58f8c5d1bf74a89e24e8f37bd9de4560f8e0ff76166ffbfd1f7"
    sha256 cellar: :any_skip_relocation, ventura:        "72325e607d5caebe80926e1ef7f208f85d3febf355734d3ec38eef329ce45b67"
    sha256 cellar: :any_skip_relocation, monterey:       "de789ffa900f03fc29dd3d5be7f012dfc3253a5fb47915dd644272ce963c579a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b86485d9ffa93fc7f1cda594b35777ac5a0058078d221c789c6a351ab3c68975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126f5ffe2407fbedeff35b521e2a57a6144bb835dd4bca2581c43b8d5a1dfaf0"
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
