class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.9.tar.gz"
  sha256 "1847619854dd018b8a4eaf369068422f7055483093dffab264cc7b662a694dcf"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fac3da34bdb683d6fe378075e7cfd3b55ed52a7ef423779d5d49f20aae83e391"
    sha256 cellar: :any_skip_relocation, big_sur:       "27f372a0db4ea97cfdcc289439ce38e30b5498a0497095f84fab1c2fce436685"
    sha256 cellar: :any_skip_relocation, catalina:      "afee4ca2e713261c85204bbf5f9d6ab17f4bef0463aacc7a3aa25b433d980fe5"
    sha256 cellar: :any_skip_relocation, mojave:        "0acbc1bfbc8e579e5945246b81d690e4ade259184ff426b2555777a6c9b71386"
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
