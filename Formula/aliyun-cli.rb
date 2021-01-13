class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.66.tar.gz"
  sha256 "ec6e711be59c96622086664abd861ea3240aae2de158ecff8db216018ee65a9e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "699cca98bfdab2261f39e6bcf47e82170ed6f63da5a0a00699028bf8a117ea66" => :big_sur
    sha256 "833404f5d1ec88a015af26df91f054af6b53460109cc1529c81d718ce8115562" => :arm64_big_sur
    sha256 "287283af41bca53d2606e0fdfd9bb4fafceb6ad0fd5c9c89384a75623df4e7e2" => :catalina
    sha256 "11d8e9bbb3b26e52bd4ef8a7f8a4cbf9a7f4de256297a26e6291867617e18d99" => :mojave
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
