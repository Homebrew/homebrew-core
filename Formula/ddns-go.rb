class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.3.6.tar.gz"
  sha256 "3480abf2907c0b991e85b42ebfbaf8ea86c445b4f90eafe3e8c91fb699cbd4bb"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d808fb6b5759a4b4898ccb44b0c31be7515450c1cc10c68326d8d29659f51ec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d808fb6b5759a4b4898ccb44b0c31be7515450c1cc10c68326d8d29659f51ec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d808fb6b5759a4b4898ccb44b0c31be7515450c1cc10c68326d8d29659f51ec6"
    sha256 cellar: :any_skip_relocation, ventura:        "5033e5a9be6b14ff438c8e39b75c1bec5df2da087e849f336c2ed85a980d97a7"
    sha256 cellar: :any_skip_relocation, monterey:       "5033e5a9be6b14ff438c8e39b75c1bec5df2da087e849f336c2ed85a980d97a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5033e5a9be6b14ff438c8e39b75c1bec5df2da087e849f336c2ed85a980d97a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04583888b4cbd6b0a1ab9a84ff633e3d5ac40013da39dc43fd9d7c221cd4e8e"
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
