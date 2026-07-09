class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "68bc1b2a966e1fd9fa191d9080f9143a892efd144d32784f365db03f5b3a2982"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c0e41c6bdecf3d68e32297f7d5abef4479be47eb3ed111bdba1758edc95650c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c0e41c6bdecf3d68e32297f7d5abef4479be47eb3ed111bdba1758edc95650c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c0e41c6bdecf3d68e32297f7d5abef4479be47eb3ed111bdba1758edc95650c"
    sha256 cellar: :any_skip_relocation, sonoma:        "22131e3207965829a53ffa3759cb51ba28d4fadce31b69981c80694041944bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2457a22e45edac49f693e4e943048d395c91c39d27b3f9f66987d0685a00b59a"
    sha256 cellar: :any,                 x86_64_linux:  "ac91d37711169ca6b22e81c30638422431ca820ef48d6e869a607bad5ac4c47a"
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
