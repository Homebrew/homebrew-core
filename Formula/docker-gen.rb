class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.2.tar.gz"
  sha256 "4a616727869840344eda89d87df6ff09d31f38133eddaf051d481299bef7e63a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf608647487efaba341e756cedd5219d754dbdf2c26f8e73e8067c9d633e56e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883cb75ad27d253a94f3fdb0501411903a4bf80111fe989bac3666209ea36e7e"
    sha256 cellar: :any_skip_relocation, monterey:       "fcefd5b9c40e8cfcd5e903f304478c013bb9acae780988fbbe4d9c6db90236c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f58ad3f97190d1183333122b3cc3e94147ac6dc3aa324aed85646f62b1073f9"
    sha256 cellar: :any_skip_relocation, catalina:       "5eb1e2b174cdf4ba83615c52103672ef0ce4ed96e893988c8ee33c07b6338e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1da7e49caa2b514eb09d8376ceef231d94abda34980bb7cca7f7032793fc1a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
