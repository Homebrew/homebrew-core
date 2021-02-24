class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.0.tar.gz"
  sha256 "5ccc467470a9020196c52ff8a8719bdb61e37ccdf579a9f7ce9a8e10d8cbb715"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff5b5a0bc23b2f18c3890b6db0872ef173eaf1e3f30ce11ca2708bb28c51b464"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ccad9cb9dce180552b29f95d5e6ba0c5efb811086a2ff5c1f6ea72688ec3d0d"
    sha256 cellar: :any_skip_relocation, catalina:      "874ce3f7dda5add1483bff0c6c01acd5cf0d333087582c0a607bb36d185ad8ff"
    sha256 cellar: :any_skip_relocation, mojave:        "37a986f3153fde7179169a3cb5c73fd6c6141edf16ce50a6bacf6bc5c952efd3"
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
      autocreate: true
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
