class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/v0.7.0.tar.gz"
  sha256 "c39e756cd2d43341dd01645f2a100437dcc7c91cf5bfed5751e71a4804575a7d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5468824588ace6ce0e2d500813f703f016d2bee99dece371628b3e4c1c309d4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84f7628bdcc0d8ddc3795f4930ec4ed4e0ad9083237c210051aa3a3977ee1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d84f7628bdcc0d8ddc3795f4930ec4ed4e0ad9083237c210051aa3a3977ee1d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d84f7628bdcc0d8ddc3795f4930ec4ed4e0ad9083237c210051aa3a3977ee1d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "72658f8dd65dc1cccd95ebacf8faab54102219c3f2442667f61c96d6f677a908"
    sha256 cellar: :any_skip_relocation, ventura:        "c5a2631a56dd18dbc987d75db932c1cb6a9825acd4799178cb59ffd7ee67c37e"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a2631a56dd18dbc987d75db932c1cb6a9825acd4799178cb59ffd7ee67c37e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5a2631a56dd18dbc987d75db932c1cb6a9825acd4799178cb59ffd7ee67c37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f86e53860af0002e959a41669eaa8093b17fd54d6a310593f10d0438402ed91"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
