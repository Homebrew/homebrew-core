class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.5.tar.gz"
  sha256 "e6be148456e8f75eb2d22cba7d65f12201f66ea8bb5afb6bdefe8b68292b3755"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb069e33815c9133ef5879bab1d81052fe03c69404467a08c2c954af4abad59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb069e33815c9133ef5879bab1d81052fe03c69404467a08c2c954af4abad59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb069e33815c9133ef5879bab1d81052fe03c69404467a08c2c954af4abad59"
    sha256 cellar: :any_skip_relocation, sonoma:        "6991d12f5246f61c06f321bfcdc25611c2f3ef2ca7322e5ee629ca0a3ec79fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770ff3cbee1d850f9f1a8a4f47c05b18024af83d65c882e0da355a00d86dba8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d07167db8bfeb478d06f424a8409a6d04dc65847bd4a1c402f0083f06cc42fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
