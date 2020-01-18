class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.6.5.tar.gz"
  sha256 "f039e1b4c2e61e9a4cf99b843eed3e9ac65580079348f2799c2f8b70d09062f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "35a97e165e4a0b16cc544675ef8149ec877fe6191b1b4a4cd31a1de9e9dfe5d3" => :catalina
    sha256 "adaa82fdd4511aa37ff7578efcf71b7d96d71d7f2b2217789170cc9d38f09246" => :mojave
    sha256 "c180e6edf12dbc23b9115358d48259bc531561ee49783913d42b660f5a29b53a" => :high_sierra
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
