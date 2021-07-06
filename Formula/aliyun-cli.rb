class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.81",
    revision: "5f1669f9b0671763151b753a23d9fbe736802384"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3763055d7869e0679b42d19b0ee1b66acba5c75f054d3911eba5c7b7e38083f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "26446f7ed8f591413bf5d77b961bd1d308e625937376f5e677aa7d192a0184a5"
    sha256 cellar: :any_skip_relocation, catalina:      "dc31a95788d4c21c8fc22c5f8fe0c21a294a0ba7b7fb61fce98be834fcc92303"
    sha256 cellar: :any_skip_relocation, mojave:        "525cf8a6992a7c0887245a9fc688ca2074e50cbd88192a97deda275f6e0cd177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7357cffe598090a1873fd25ef7a85b0bc80d4debfd9d8ccc8175aa368e962e"
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
