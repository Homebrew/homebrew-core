class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/46.0.1.tar.gz"
  sha256 "7325c5a8025c067169e638cfe9aa64cbe1d05948d8c5343b28d8e1a3ace70c34"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5047e576e061a87a9d3ce284badb4debfa3ec90449a1502417e8374bbe00e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf882bbde2792f3971a9f00a5a133ab586c7af90fce07f37c87c4ad4a86ffa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918830f7e1021dbbb7c51be6ae822ec4461bb6214bd759adbb90f2063bdce95e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e55dc6c9bb9d2fa337863ac5f949c75946df314322b48f29620eac8827938f7"
    sha256 cellar: :any_skip_relocation, ventura:       "a2760dbd946c8bc49b4cdaf57fc4171e66cc3aa1f460056bc6e5d8ec2a9cfde4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34111f178b04fdd4d98f372146c7d19a7d282f8ad868b76a7b8b30cf279684e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ae968ca941241d98668b1f6b425c509c007d329cd5267629b74f7d69844e49"
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
