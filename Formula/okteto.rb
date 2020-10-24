class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.3.tar.gz"
  sha256 "69319f456d4f0930b222de76b62b5808df04f3d7d540bd54049ca07edcc38510"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa102ba4116a2af3fb0d8296eb24fadf2aa1f95d6ed1bf3ffb9997cf9e4eb346" => :catalina
    sha256 "1181516dc3e78ddc180183a60969b259bde4730a35c563f3b151b8128c382073" => :mojave
    sha256 "c708a4c7c008bbf60e1ac838750a88fa9ef35f9482e796333be28e2bd6f5f666" => :high_sierra
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
