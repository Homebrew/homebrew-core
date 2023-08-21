class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "c7ab7cd84dacbdd42f6917c23aa2cba28eb016a38d29a62782b0fb0956b1f201"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc201d7f8f6091ef39c4c41f2b38f76a234ccf7d382df7a47dbe93404e3d6e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a1321369f5be51da5c7bbcc650702f8940b06b7f9b1a815513cac55eaacae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07c3c25aa1d79583f142365447ef5db0ed2384c27937e2c8ebdb03d3bd8b2630"
    sha256 cellar: :any_skip_relocation, ventura:        "06766e0563f28cd1f2d5095440e80edc5f37a09650e8339d1cd2a6871082b628"
    sha256 cellar: :any_skip_relocation, monterey:       "dfebb1cedc6ffdb716c5bdff1e90d625d71f1a0cb6c3acfab5f8925c2f16520e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b65b11dc039b405b52a1607e7af423fc64d1b90db62b827204cf5a435b1eb901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ddf41107339a626d3b392a192c9f1ccab9c068d9f2f6c9ecc0c33297c685c2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
