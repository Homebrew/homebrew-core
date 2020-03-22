class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.1.tar.gz"
  sha256 "fc4627584e4139d37bc8d8ee3113be98a9cce07b582724e24c2f00f1ec32ece6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d731216c3415e8ff53d37341ea7069af6d3c8da6b5a0282ba8bc263b0874af5" => :catalina
    sha256 "02963b8232aa27d8b0f5ec3c46f1d797848eaafa89c0819947626f6fcf4df0da" => :mojave
    sha256 "1c78daccb9ec064317b8f6c162f5998a8beaa3d50a262c2eabddd950c76f1f92" => :high_sierra
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
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
