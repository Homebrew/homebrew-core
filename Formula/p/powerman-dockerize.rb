class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "452e7842984480b47099bd89bf7823ceeead62341a0e2eb984155f16f88311de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34efe528eb1fa78a9e2b6559920c0f546779503f5ff2b2099835e103ce47b6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1efaf7bd8b9265c75c0aa12d7bbf22b26085cca10b65e26260ceb0875c967c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b734ab7becbf23666f211549f3f3a874b2968bddb784acc9c025c9823da9348"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e52f53545a65ad1266882a7680a6a923101dd16cca111a7acc3f8321bbab301"
    sha256 cellar: :any_skip_relocation, ventura:        "1d2a014ff83243ccaf7f211bef9f5b37c499b3f13bfcb723711c02e3972a87bf"
    sha256 cellar: :any_skip_relocation, monterey:       "6f952c99b24c09078edc26e395c738b66bee7828d47fb384b0a51ccf91b3293c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3460c6247b74f3ab0e19ea19ac9f521a0266bd390e1a44776f75aba9737f1097"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
