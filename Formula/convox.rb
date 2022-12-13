class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.2.tar.gz"
  sha256 "021163f6eea84c298d94bcbea5ee760a593b4c8a0ba870b03c4911be78cf4d5a"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa0ca7ca0cc100d4019e53edfca72428bf4ad2733470ea76643ffa1e544f796"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dafad33d29fcb50d30ee3231dc5a715407c7fd764ace39fdf384cffb63725fa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b90bf2465a98306acf1bb3d8a1c95c0160170f160aa5094a7f2930ab1c99a57"
    sha256 cellar: :any_skip_relocation, ventura:        "ecde5d53ec35ec4ccf0634f498c5f8802e6318d8b0699baffa36baedc4725418"
    sha256 cellar: :any_skip_relocation, monterey:       "9e964ef72a57e0ebd09645a38ac31fa61f70f651e286c85911764762c1d3a527"
    sha256 cellar: :any_skip_relocation, big_sur:        "4acfb7c78b7b1ded0ce6384132f8880b5a2030f07b7b1683f580881c542fb637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44906f7941c848135beb5b3950b74c4a62a07b355fb0ce38d9e53b57fabd6e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
