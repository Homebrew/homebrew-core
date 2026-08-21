class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.11.tar.gz"
  sha256 "641c6502a8fed03b2afe89375dc88cadd104baf5f87a7d6866e778a6cf675c32"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "505364ce1a7376679cb1eec85d5a34dfc2c0500822eeb75b5bbd309bdd94c19d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505364ce1a7376679cb1eec85d5a34dfc2c0500822eeb75b5bbd309bdd94c19d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505364ce1a7376679cb1eec85d5a34dfc2c0500822eeb75b5bbd309bdd94c19d"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a5f154b2dce4d23d35dcd24c5db7a3a276e541d89a52488026514babe89840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51756cb6e7a0af27d0d0d0bbe6c1927e6093eacfd88780029b508f2da69f170d"
    sha256 cellar: :any,                 x86_64_linux:  "34c2d065befef733e752cdcedac39cb8f855b82f83bcdab8928174da9936992d"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/2563691c22229a0b493606e11166b95896707095.tar.gz"
    version "2563691c22229a0b493606e11166b95896707095"
    sha256 "7ba54333e467ddf5b25cc93ef883742b1817b44c48568bfee699450544537e31"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")

    ldflags = "-X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
