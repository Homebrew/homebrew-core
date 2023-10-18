class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.3.0.tar.gz"
  sha256 "66e19adee6e1120e084ea3e5631842207a7c3177d7292b97cbdc2643c2f284df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ffd74f1304baa4b8e1db3d8c89ad49b3d4f299bc3dc8eb50929377b3bf2072a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3900e65f1f05650e054e01bd16c14d750158eae9e4281ec93c35337e7baff8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf3900e65f1f05650e054e01bd16c14d750158eae9e4281ec93c35337e7baff8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf3900e65f1f05650e054e01bd16c14d750158eae9e4281ec93c35337e7baff8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2fa6969f2f6a04dfc23419e3f86fd5cfb7603d871f0ebc2eacd83b8a1f79537"
    sha256 cellar: :any_skip_relocation, ventura:        "b77141019e89422926351eea9395ae80fa4d5b4fe972f2c9d9226b0ead392c52"
    sha256 cellar: :any_skip_relocation, monterey:       "b77141019e89422926351eea9395ae80fa4d5b4fe972f2c9d9226b0ead392c52"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77141019e89422926351eea9395ae80fa4d5b4fe972f2c9d9226b0ead392c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ebfe8c10c7fe8fc734f7ccda5bded62741879ad3a8ad0000da779a9ba0671d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fork-cleaner"
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
