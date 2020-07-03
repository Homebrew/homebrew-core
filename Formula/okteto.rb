class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.14.tar.gz"
  sha256 "ead78ef55439f66f775757886ccce26cf741e9acbeb557dd6a4ee0e2f7c463ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4580da25ca78cb6dc4ec045b6e18f0ef3708d02b4ab962d454324890962656f" => :catalina
    sha256 "173848fd9d90011204bf416e46f47fbdff7d80d788ba8979f5dd37c85e4c6dcd" => :mojave
    sha256 "def71f2dec68765d91d0b6e65d20ec73ff336ae4123b4384e5e7535058b8c767" => :high_sierra
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
      forward:
      - 1234:1234
      - 8080:8080
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
