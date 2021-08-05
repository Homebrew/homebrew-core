class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.85",
    revision: "8c7cd9e9668b3504bee7641c4880df466b413650"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98ad5ef282035209452335df26248038244f4cedfec4569f0bc20983721f04e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffcb9ac2a026d03c4ce5b14d72854d80f0b1a9b3c872b154376e234a5ec1ce9c"
    sha256 cellar: :any_skip_relocation, catalina:      "0b2de14eae16de9a35a2e54053e8a81dca2214d2afbfd17ab892a6cc4ac34e07"
    sha256 cellar: :any_skip_relocation, mojave:        "c3777d8c97a6f76634fed9b54fcbc61cf7a98b3f7b83d4152a07b396ab7f8bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec8f4a20576c6b7c19938d230d0d8407373b142a06ad760ae3d7e7ea413ed11"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
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
