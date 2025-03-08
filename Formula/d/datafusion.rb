class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/46.0.0.tar.gz"
  sha256 "52f879a21a36cc2ba55743b7666915a06b745e25091f5395acdd20221ba95f52"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e5146cf29bfcf33dcefa82e2e81400dd12666f26f6941f13066da966038b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccd7bb4516378a8cd5774ec1684309b28266571772743371a92c641acc80f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96a948be8998b24181b2dec05764a2fba2fefce83b47471ac71490dd390517fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ebd1c4a15a43474dd5e7e14b0fd6847c257881c364633ecae02125fc7ddf40"
    sha256 cellar: :any_skip_relocation, ventura:       "51c12558f5b14cd19c1b0f8c32135b097308fba7a23b76e363e37dd24f2522cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db56c7a5160d14742454aa8bd3c2a56d72622a78a8c98bfd9f73694d951a3f6f"
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
