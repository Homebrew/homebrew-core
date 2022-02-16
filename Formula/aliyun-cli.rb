class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.108",
      revision: "1c81252d4a7d6ab668ba5ce18a002df7f931da10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541e9b3aa88071abc8c60ec3286bd469b4b60429f74d8518881fdb6bdf02e580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29c4184daf7ec5864fd8850fd88e40abdab787832c184e1e6b3d1690e5d02d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "7fed4d7718e4665257c085df7fa353cfa1388e2ff037c8ce4cfa04d75c0764dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff672c266e679b26556bc83a53658e486beb7daa7b9e52203e3a758c5976caa0"
    sha256 cellar: :any_skip_relocation, catalina:       "d626e1194c564892e6c8337657c6ef882749571f8027b07628c26b0ecad35abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96a9720397b380ba11c9bffd8e94352f3d1561f0d3014fdbfd4515fd131c789"
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
