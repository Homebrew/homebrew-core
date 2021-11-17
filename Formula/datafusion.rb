class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/6.0.0.tar.gz"
  sha256 "a40f74060a8b9fdb4b630a57c2b36f02961fa9759f1fa0d6568e34e12348dc5f"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "394188eed3ebc9c53ce4cbd556afe64f9624360649a81ada080a4cd2c9a78703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94dda735ac09c8bd22d6d834c5c63eec0ddd255a8b3b52754e5ddc98f120c2a5"
    sha256 cellar: :any_skip_relocation, monterey:       "8025c852966d9eabd90b2037617fc25937742373afe751b0f8221d42200cfd2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ecc8a01be47ceb9a53b39976696afa87c0a85e81a59d40de170047684a3a692"
    sha256 cellar: :any_skip_relocation, catalina:       "58eb797586e94e80f2df63d160d5b166cf1c1b86be601018a54134d060175546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ec8d683cdf7f532d2ec22ebdcb9ea40cfd2ee95e5ae4a855805ef3bf98741f"
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
