class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.102",
      revision: "ff17a27e4d420a90254da069e3a5f56d2bdc12e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3ef658a051510d5082722d80d140b7f54265d6614f43c3489a136d6826e192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "560ef3d90cd0ac55d2e2e3fab1e8dab3d0d280826905c769f1988bba25f260cf"
    sha256 cellar: :any_skip_relocation, monterey:       "b91d386983d3be68a82282ece2fd82c0855762ba73821e539d672d0d55593265"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b9de01eb02d19ba8191beb7652744c4815b8bd16febc2850ab4f61156ae3040"
    sha256 cellar: :any_skip_relocation, catalina:       "843d9a9851d53f783d802e7bd7e6240c6678acb81bad44415bc65ed89bfd8b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa26a2bd63039b619e023dffa4932f4e79325b16238cd401eef6a63ae40202b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
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
