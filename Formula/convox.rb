class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.2.0.tar.gz"
  sha256 "8eea232ac0eedfde49f85278134270066726393d876fc5565e06544b51fbace6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35bd4bbf1075f7e0be3e98b40f1c06498e9486f14b2494030d0961435f139b5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d56129c8572dbff42bfd70d3ec3a0942076fae95d7302601d3939706e996d2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "8ad6aa2384d9ff7913dea0f34bbddaea0a0ee6d6595e8d7012ca343cb59d6821"
    sha256 cellar: :any_skip_relocation, big_sur:        "79b82abb9634afdde41d628caaf9998abd9e2cdded3f96e76c7fa1dcbb5e2dce"
    sha256 cellar: :any_skip_relocation, catalina:       "d752e2395fe02e5b7faa9b284952d400af2dacf5b9f81ede4ef898010b077d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bfff92a4f6ef6c79f28b8cedb75604ba802c3329e6db074613693ce92b5c806"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
