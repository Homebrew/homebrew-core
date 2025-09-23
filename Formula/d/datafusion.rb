class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/datafusion/archive/refs/tags/50.0.0.tar.gz"
  sha256 "70454b553dad828557f3b572fcffb6b58e0e1bcb2f709a37262e65196ac6fa22"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2da069115b559264382836d682233de451f98dfaf0a8e0b10e5d973da46f218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2543023332384c0b6ae05ac1e973c23a85a00cb253db3965cb6c2454f9fec2e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a218b021ad81ca237e26ac6266ac119c8bfdd54f88625fe35da290e9d6671518"
    sha256 cellar: :any_skip_relocation, sonoma:        "c46f8a54b9389b4c613380df12972b8efaad41f346cf6d02ec99a6946570e428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a0e0690d974a8e26cb663f09288082b2b1603d23d448ff6b973ed883ed533f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d3b041c07443edf8fed018c8383bbbf2020d2326271bc16a7ef877cc533b02"
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
