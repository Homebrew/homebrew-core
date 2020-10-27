class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.3.tar.gz"
  sha256 "69319f456d4f0930b222de76b62b5808df04f3d7d540bd54049ca07edcc38510"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b39346a848b2ecc8977f09ff2f460e6ffa2d319494484d858a87d9707dd56435" => :catalina
    sha256 "7aa4dfd65e8ce992bafc4bf30f60df40a93de6b458f7bd65c984bae7893b9818" => :mojave
    sha256 "d4e12778b09920f9eb0eb62e8a1e75e4e477f36ec80f245afbb4d42220b8eaf7" => :high_sierra
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
