class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.0.tar.gz"
  sha256 "f4f5c478f966a1d60373c74bfa1e934c9858c0502e2da1819ca00ef7e0fb1ee1"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59f126eb20dd8f3fb93a7e13d0f87d0dcaab6e1c6abd75e383a351710732dde7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ef6bc73fd9616054bff98f4c8e89c046a532a6e3af42e16f2b67058194029b4"
    sha256 cellar: :any_skip_relocation, monterey:       "147b63b50ec008943f52fd194fd96c662be06f62ce39708b23191989f96678f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8cdee91d1fe7dab1920d5c74ec1aaa9b4563af112da17b364085c62b7147a17"
    sha256 cellar: :any_skip_relocation, catalina:       "685dbf1fdcc9ddc0462478ade05aab75ddb114a000002a58f258dc0116a082e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9568b8ea796354bb94a995a06d11dba554770931342ae1b792c5a4b24086117"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
