class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "b2a2b5208d9b515b3a4ce983e1e0004a23987a2d7fb4f0d3ba119a05f04a409c"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f304f040b6e47060c528cde24f7fb925b77fa4afb98dcc41b4d3e6882681983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f304f040b6e47060c528cde24f7fb925b77fa4afb98dcc41b4d3e6882681983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f304f040b6e47060c528cde24f7fb925b77fa4afb98dcc41b4d3e6882681983"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a599fb7f0d3fe9363afe0d2ef9e12f47669cb445605af22f0b85cb3572ac03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4ce96345f4ead9d9a89437ac3b49159a2b4ecee22724b1a39bb232d3053e19"
    sha256 cellar: :any,                 x86_64_linux:  "2a145ffcaed87cd8ba49850c054437ab4ae51769e0bab7ef95623e1a452ed528"
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

    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
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
