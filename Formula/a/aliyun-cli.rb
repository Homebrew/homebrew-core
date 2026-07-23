class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "1c0b01c6cd033e02efc94b324ee7930fc3bca738d5f6ab9c12280709b213fd01"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb34de0a66de9ed59de9c54a72816b99ba81a8c42d7d52742d41c9acd706b162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb34de0a66de9ed59de9c54a72816b99ba81a8c42d7d52742d41c9acd706b162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb34de0a66de9ed59de9c54a72816b99ba81a8c42d7d52742d41c9acd706b162"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad91d1be6f41c36e14f9be4eefe33d60ce9743385df1eb34944f06ef44f03dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bad89482dd4da06b90f7d37c5567591ecc33fe415e789a0d2b82f9185e16856"
    sha256 cellar: :any,                 x86_64_linux:  "48cb93586cb6a7bca44a7cbb089e53d1d0cb2916cdf41c3205c2bbc2c11484c0"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/2563691c22229a0b493606e11166b95896707095.tar.gz"
    version "2563691c22229a0b493606e11166b95896707095"
    sha256 "7ba54333e467ddf5b25cc93ef883742b1817b44c48568bfee699450544537e31"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")

    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
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
