class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.6.4.tar.gz"
  sha256 "a4db405b2e4502fd2f3f155a99b9e55a4a7695c4049596607e58f13b47cf3735"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d002ab9f19603d5035f12d70f9f4da7e4611622f55fa831a0b5ff40eda6a5ed" => :catalina
    sha256 "68f6384630f743b2b9d3a3071b64f5c3b92f50f79b880d16cb2daa4d0dffdb0b" => :mojave
    sha256 "d76c8b4db709ce818b8a632d9b4db7ad1a078345ee2bd0ccd617e3284dcaa68a" => :high_sierra
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
