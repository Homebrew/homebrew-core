class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-54.1.0/apache-datafusion-54.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-54.1.0/apache-datafusion-54.1.0.tar.gz"
  sha256 "226dbd961c95cb606ecf1591feb6a1693863a7d8910ff2b35ed0bc7eca8c7101"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9113e549915ae4800ed18ee4a0b23baa9a7f9c84ac5727293a8d344b9fb119e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20f6656941b540afd133722442f1764f9bdd41f11dd19ee101dfd28af18144c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81eb291e6191bc44a96adcb29f9f9b94cfd46c0c57eb6510f44701e7f333e813"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff62886427d0d38984f593a61ed8712d055c9a5cf0bac7ba48089f860ce5e337"
    sha256 cellar: :any,                 arm64_linux:   "6a8b5f4080a02ac4e7bb5cba5dfedf9e3dfcc3e09a5574d6c7f3c6de2dc727f5"
    sha256 cellar: :any,                 x86_64_linux:  "73ff26b988a1eb6f58b0af369e08569f3779b9b0cb8f163ce638b6d2dd8a89fa"
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
