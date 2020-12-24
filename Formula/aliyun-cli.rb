class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.65.tar.gz"
  sha256 "eb918d78ac8908b74010993dbd266347e55e9fdc317f2145ed35782dbaf9d253"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6434d66e064ddf2ba310040429fb466f515faea2212aefcb33dc1e4d3fabbbdb" => :big_sur
    sha256 "211e3ceef9ff7d4a83d910b02278d1121bf4d79fcabd4d762f345770f87304df" => :catalina
    sha256 "f7d358dbc57f8ed5c4fdcfce826d001f4f46d141c090e7c5f9f4553cbaeb3f7c" => :mojave
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
