class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.14.0.tar.gz"
  sha256 "275afd507c2bb4572c5517d8549d7dc5a07851e5d8373ac64f10c43cf3eca567"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a8cb6e38b37839d7c77c9d8b65e192b05ac73883bbde64d9251339f2abdcfa8"
    sha256 cellar: :any_skip_relocation, big_sur:       "072a469b2e580b811bae7a41c988d64d8795042e05f53b5d1a071fb091e795d9"
    sha256 cellar: :any_skip_relocation, catalina:      "31ca6d551c19fcc8e4a3d490cc4cc51dda0545bbdbbdd53e5de727ff36541c48"
    sha256 cellar: :any_skip_relocation, mojave:        "2b9f9a134dde437773435dcbf96e41ec5ed9d4ce638d2e68f5691f319b54f4cd"
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
