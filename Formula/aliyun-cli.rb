class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.71.tar.gz"
  sha256 "278cc785fb41108ad4d711b5818211b1ce568c7c724a6353858a801f54f03e20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3e2a6b0225b0fc3fde3d5b170387d954c758fb8f709e0ac0dae1149a804e08d"
    sha256 cellar: :any_skip_relocation, big_sur:       "342902030b8f1a9cffcf1d509892e371b5ad353662b0cdfd968f80ed9a576ed8"
    sha256 cellar: :any_skip_relocation, catalina:      "f3af03188008baca06b8136918e40e8521d35bdffef04aa1ee4d9a8e432519a5"
    sha256 cellar: :any_skip_relocation, mojave:        "53e0ad5815a9fc6840d43794fc790f17256c8d0e52b0fd8b1911364b8674d2e9"
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
