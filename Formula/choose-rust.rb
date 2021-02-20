class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.1.tar.gz"
  sha256 "6c44170f456f410370ba31d59bfad1f54a71ba80a79b87debbe235672a2ea0dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9298f1cf7c37858a53411a839bcb244357f744d9d1989db84d425d9687da0fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "1098dc1fd81d357db4f73afe62997df638c4bf7b6e78dcbda8af89081fc5acda"
    sha256 cellar: :any_skip_relocation, catalina:      "761e6a2bf7d2455352a09ddb67efa9dcd192555267706bdf1575a1f662a63c4c"
    sha256 cellar: :any_skip_relocation, mojave:        "56897b4f0bce51d9c2dbd9f397fcac4dc9aeffbbd25b40bbd335b7cf33405831"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e54e01d106f23c59df123d0ca5bdc7c51bdbab46dd33f6314af6fb6c811eb4ca"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
