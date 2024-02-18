class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "63ca6d1b9c3c951d03cf36e61528495401d8638948a7cedbe5edeab39d9eb8ad"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02084ddb9d34d3956a441875dd6213aabb47b037dae51852734c44c8e6e3220c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "955f889dfeeaa826c73acd8dcedbe1f41d5264984901643d04c45f41c15f7eaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eadca14e751765b37cb76137a618cb75bf8d605186250698c620bd2c37e9ca6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3a6fe9f22d0ff9e315d339d7d386757fe49e932e1804af10d82220e98f092b3"
    sha256 cellar: :any_skip_relocation, ventura:        "89156fbf95efdb11792725c02f3b5298b5972ea6cd0ceec3f8bd5ef9eadd524d"
    sha256 cellar: :any_skip_relocation, monterey:       "fedb50415b35ea18c5d33092b9f3fe5a9e26062fc053925ab2f2ae990a716c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce1651ed5381e69f0b6a9957a43231acbac8922bb169efbfd1e601511ba67255"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end
