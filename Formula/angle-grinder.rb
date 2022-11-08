class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.18.0.tar.gz"
  sha256 "7a282d9eff88bb2e224b02d80b887de92286e451abf8a193248d30136d08f4e0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5bfe41bc3da2856559dd65f1d9a73af5c556d56196d0c2c1d054f59f9f092bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92397f939f662d67d0928b55d2a18a1dd437adedbc28fa9fcf14cfe4cd7399a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8084437b814e61290e1a3c3926c9ffc0f74e72df0257fd486668e7eff6c36226"
    sha256 cellar: :any_skip_relocation, monterey:       "f076b9d8a5985d4ac78c03ab39a5509dcf1f739a12cb2b76c993362e43ce4950"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b5b0da0a26c01cb3f44ccf35d97306e89478b051de799f424774cc5a8ea7761"
    sha256 cellar: :any_skip_relocation, catalina:       "a28e8958631f10f49a0e3cb3e9610d93bbb8a0b6b056345d8ab48a5fdd62f539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "896f2ac749441e8c857638978be17904054ff93a382119b9ce46b1b7160d5e2c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
