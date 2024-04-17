class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.3.2.tar.gz"
  sha256 "7643dea28dfaae0923aa895797649c063c27cae4dbb1bfdecd5ede0ff68c9f0c"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "374faaaf8a924dab252050a1df45d9edfe2da9e6551215afc4c7f73a734a81af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd1f9abc03becb8fba214f84f479d24f066f6fa5280e4d33535fe98a5438c5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b943d2ffc7b88ecb1cc9a3ec14fad598b3488d99eb958510bf327f18e8d51641"
    sha256 cellar: :any_skip_relocation, sonoma:         "a99cfb788e3ce6f7a3bb13225076f3d9d6da9b746e2fdf1132227ff68a477e23"
    sha256 cellar: :any_skip_relocation, ventura:        "cc809f16b08fd8e35d5670b8af5a82ff0a9d3ea1884f4cb38f3902498c99cc8b"
    sha256 cellar: :any_skip_relocation, monterey:       "af10e2df4bbfb615a4ec1c4f71892dd137f77b5b50bccdb1e79f5f865ed3bd33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13684cd71d4356bd54d33c4e907a7a5328ff350426b1cde321aaab51a810fdf2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
