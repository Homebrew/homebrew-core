class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.135",
      revision: "24d44a75773022c16cd54068f15a37a8385cc5ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632356c3a3f95f69d1874b677f04f0d8bbcb692146462d201f9831b8b9a3b2ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c8de7963d03ce92d4d1c76945090701b4785f7a066937d2f7adf2f61a92e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a84f60d2797f462da4b7998aaddfedb6b048cf5c606280a83affb9e7a11fd7f"
    sha256 cellar: :any_skip_relocation, ventura:        "4a6c2301948f9d5ef8c395ec416df26c4fc829e40222a3a1219fe7ffb8142eae"
    sha256 cellar: :any_skip_relocation, monterey:       "183a6b9995bbf8e436fd0f03045225f2269fa6a30da53d132801cc11cd485b1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b5d9d1df527ed47e6378c1633164d39ab5925016687a878fc136d211f08e9ba"
    sha256 cellar: :any_skip_relocation, catalina:       "2ac52c8edbc3b7d61a136fe00a28480d79a7f749f8656bbc6f03caf2101e3e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e201100f746ac80eae9a8f0b27faf2f183410d3d58ee843620de588f9492750b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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
