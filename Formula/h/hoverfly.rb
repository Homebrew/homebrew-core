class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "2c5ae510aae6ff20d4df52d71c14581877bc26929f322e79b8f534ddc8ff6d61"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee5a02a6a9186d1a0a38efc506893637169fb4efe1844be887d63f3b153587ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a0fac021abe6dbfb04fa22ead1744dbe9ec51b7392847e6923875e54e1e0d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45e84496ca2491401b68c026480b6f6f6a487599591fbfd963b02b6ed4e954b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "797b14e51ee2add906e2aba0767624a00f4b1b8edd20a0a42027292ddfc62dfa"
    sha256 cellar: :any_skip_relocation, ventura:        "2f8edd7577ad0fe601d675e05c10f0d85c3418ce3faf71cd80cee6731d0ca6e1"
    sha256 cellar: :any_skip_relocation, monterey:       "7c4aee126332235ff07c42b3915a70abfe43e589d982049a97176f4e757bdb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f078e76c6eb8d3edaaf93db40ccf4b068a28550bfc1b54c15c727bd93005d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
