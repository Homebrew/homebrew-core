class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.18.tar.gz"
  sha256 "34e7280ff55842dcb7dfb49f2e2359fdc2628067db4f565469c2c425ab7f5a29"

  bottle do
    cellar :any_skip_relocation
    sha256 "39f79859e55f4defd1505ed8dd32707307a16f59391c09570549da3e99ae3653" => :mojave
    sha256 "137558b078bfe61c80b7efe3d3e677bc0f373b422aea2c8b35f5329f2d2e8ba2" => :high_sierra
    sha256 "b3c1feced1dfebb4e04f3d7220db7dc1bc871a6c64cbf5b2ef0cbb5295682f3b" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags", "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
      prefix.install_metafiles
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
