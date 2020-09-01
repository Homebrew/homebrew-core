class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.18.tar.gz"
  sha256 "a628d6c3fd8cef2b97b148f77bd3e697ac32be269fe4fe507394763e2cbf79a2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7db58614a165a15db54fbbe99aed87ed0b66a468dbb4db78b4ef6f573479429" => :catalina
    sha256 "b8ccfc8b1d2433c99a67f0e89378d5b6edc0f64aa2e2d1ea2cc4c17eda106210" => :mojave
    sha256 "f255579a5e3280256d317f2d4bd270fc21cf242d4ece99a005ea317fec847dde" => :high_sierra
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
      command:
      - bash
      workdir: /okteto
      sync:
      - .:/okteto
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
