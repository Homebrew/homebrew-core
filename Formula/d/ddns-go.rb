class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.5.tar.gz"
  sha256 "b3fff8b758ac6a1bb3b6e463248009e3fb55148ed7f618213f79f6261d120338"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adb4143b84054aa5c884a7ebe70fca2dff2ccb039374abc07fdd94d4cfe9c339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb4143b84054aa5c884a7ebe70fca2dff2ccb039374abc07fdd94d4cfe9c339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb4143b84054aa5c884a7ebe70fca2dff2ccb039374abc07fdd94d4cfe9c339"
    sha256 cellar: :any_skip_relocation, sonoma:        "a721d5f5bcf5c23565dad4bbff5902fcebe4341fc77419a3b54ccda89d216057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c813db3090adfd2c72aa8b56bb099c5402fe7ac7d02742d43040465319686967"
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
    assert_match "Temporary Redirect", output
  end
end
