class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.63.tar.gz"
  sha256 "fcc41b673eb8d32fe18eecaef7932d376753173daaf4870d1f56891469c98864"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4ff57bfe10152aad2b1201b71ce036a8cc16ddcfde48f4aae33dfdd5173b004" => :big_sur
    sha256 "4209e60b784b811d9bbcbc49077ec8b50ee3affee1db4c5daa63846f27d2a1ab" => :catalina
    sha256 "754156206f38ab785d7fee0a2f84db57b5f7b000e77a7306289134c5b2b2dd7e" => :mojave
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
