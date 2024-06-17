class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://elv.sh/"
  url "https://github.com/elves/elvish/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "6a6006015f44def98676eaed611702b000d66838c0e76da572d517d9bde5c388"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88ee574932fe5fda53dbd6401bcdc3e81d9b00b5b7304cb6e647988d391accb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7390363b910d982778eee274ad42eeace173e53c2c3e57f3976b0e713176823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca136fa01fecaf42c11d71ebfeb8ea94d42e4de8b20048227613f66bca5fce6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b161b390df37cfff23b66d302bbc4a0f389cfdf40ba5f2fcdffda727f1486863"
    sha256 cellar: :any_skip_relocation, ventura:        "60458a758458e02016b9db4248e6dc8592960ef49bbc36cc29beb82f34453357"
    sha256 cellar: :any_skip_relocation, monterey:       "00dabc9f18fe5ff5c8b7d56b8261551d091f3b50472c0447a2e1bb2a772e94a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c359bc8b49daf29ec88e7846b74956e7bbd055d3ea524b65fbfc8329298437"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
