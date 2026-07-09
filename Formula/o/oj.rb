class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "62bb13e53da917d2a19ec6dfaf03df738942a41f1591c6f96bf01cbec7f3ee32"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbbb9d894e20d489ba5948f952b3925011a0ce794cb59036e3f3781f39f03e4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8bd8befae482fd6c4a4dabf9638355cb6ae93b7057824d4815a3f84fb6f7814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626ab103ce6ee8e3a49ba91e164810fded698644f4f74b2db7e82e022d07c603"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f1f6e98c939eb157643a97591969592d48d79d993d37cc91932407bcab2cd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404f8c8855b870535e8a06b903de2b48bcc6bb2c6c82d414e7efece76afef50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5041c61bbed869d5d9425c59b5ff16e5a9cc99e176eb84cd5374a5f2df3c6ec6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
