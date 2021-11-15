class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.15.2.tar.gz"
  sha256 "013d27df901c00dfb75ea164dcc89e93c3ed3d300086d30eff23688f4519c103"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f6ed16c9215d9eb3f655d7f6d6e8662eb6bafba47e2c966f031cd8f61e60b2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02bea931968c6d43c8addab05167b4581a97157f8f232e9f9455f1307559d92e"
    sha256 cellar: :any_skip_relocation, monterey:       "b4219bb2b00a45fd20b65f8e5bcc3a88e1efa618561aa7f3b1a27111e8a55830"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ef66a80dbf62ec07ccf9646db9650b56862a4908eb6d9bd6f481f754b4749d1"
    sha256 cellar: :any_skip_relocation, catalina:       "f978e4066823494d805bd1d9672c0f9cd9b0d5917763b221e5d2b697c6fa49a0"
    sha256 cellar: :any_skip_relocation, mojave:         "6512f703828def15a4763fea61299339795e808f9399c048e8807fb1d5e072bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7102a7561fcf110fd0d7180087fa5697360915ac4616bc1b321c64e3cba1830a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
