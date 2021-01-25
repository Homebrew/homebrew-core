class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.3.tar.gz"
  sha256 "ec61e04d0ca746a24e9f6ec1819e39e277cbb141c53c0ea17b8ba1bae7e653a3"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "63a5f3d379e11891cc9ce77e0a4bcf15eef7cccbbb947af8856b701a794db6b8" => :big_sur
    sha256 "84968ad7308f85f9fa1dc9d8602c31871ac8957bb976815313c8769bd2258b14" => :arm64_big_sur
    sha256 "28fd6531d5ff6cec6c87a1e6d9d199f3224c89836cfb7e11640dd856d139573a" => :catalina
    sha256 "4490d0aa67a21c2231a5001de139f475d86f3e50123ee497b305fa422080574b" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command: bash
      sync:
      - .:/usr/src/app
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
