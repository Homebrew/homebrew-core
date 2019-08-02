class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.23.tar.gz"
  sha256 "9e9c04eb4a56f9502b0222e03be4a1fbc8ea575dd2553c2d2ba8b5330ddd8c4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "739c81ab5a1e2b943513fef67d2ed8d82ada58452176ad731a54a4c80689eb49" => :mojave
    sha256 "45c2856e59212fd3b4cc72197bc214c091aab8b9a6a920531166a4d440346768" => :high_sierra
    sha256 "d79c96a53caa5572fed5688e5ee0d75eb0fa4203a4fa31272b1f6ec6e5aafa8e" => :sierra
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
