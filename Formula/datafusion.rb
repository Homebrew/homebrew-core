class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/15.0.0.tar.gz"
  sha256 "9957592ac28a6bec7d3629a6f2219dbb23c6d715a1a066226a69eeb09f159b32"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64f7758435a03548b7d9ff803f705c548517ddf2a175ed140c9f66d94a447112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f434256c090c1386fa5796a9d20dcb4a9e2e97ef0bef018ddee7cbeafd2f4e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "922fa20d8e3eec528faa9b821347e1ec9889129e9769e887b014e2fedfc10b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "d07b353892376990a81cbccfbb59d3fdac372e65f1f20901759f4da496efe8bc"
    sha256 cellar: :any_skip_relocation, monterey:       "d984eb85c937452d57ca34385148cda6033f93e81eb667e1c856235534eb035d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3425b82782f4b196d0b49f3fa536f77c9e80d665d68ec4f2c564fdfa975bb628"
    sha256 cellar: :any_skip_relocation, catalina:       "2be0da34b0874ee778a13ba65c48e7a9a808ba01c6a3df7754965df517e0b550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47262f03662d8bbfe9e254cddb2ca60b0ad786d2d8a5a411bd5ad4c0782439e1"
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
