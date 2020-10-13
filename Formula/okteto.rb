class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.2.tar.gz"
  sha256 "87a3268495d760943e85ce52a036f87269938b93df5e86edd40ddc0836809be1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa002c3af9dc17c894ba08a7b6f686763d22c98964d025ec45d7d7deda43ff0f" => :catalina
    sha256 "2194a95a4230a88f5c96c242abd9d7eff74ccae0e703d250b39bc87789f8b8c7" => :mojave
    sha256 "c80d1ec0799babd5f82292e7fa69b9e487bd37a91e8867ce14ea93ceb5aa9573" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
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
