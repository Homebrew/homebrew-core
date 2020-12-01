class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.64.tar.gz"
  sha256 "ed97e67d12ab241d2964166f00bb4ecc482cf20cebdc51fcb6ce27638ef41e98"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e043d9a30a464e9beccd8a2a356946516a6db24c8e2b2f9cd9d9e4c971bc8ec5" => :big_sur
    sha256 "daea4390c5b1ddd218a72e2c1ac7351c7dcc4efb12252a1153bbd3b037435a0f" => :catalina
    sha256 "81afa1ed8805095cbba79a58132e0fa12a799e1f8758be3576756dd293439a80" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags",
                            "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
    end
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
