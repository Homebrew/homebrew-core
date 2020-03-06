class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.0.tar.gz"
  sha256 "5fe146bf15dd406768df9cf9c0dea35e2b5dcde0a1a42a7e7e5678f8ff8ea112"

  bottle do
    cellar :any_skip_relocation
    sha256 "13e59bc9ff6d603038eae4b52172a3c8777986e4a8ec6a4cf7451bbe2d57df18" => :catalina
    sha256 "5028953212563c4dbcac8f874d58dc31d1827ae680fa7470fdda7b223436225f" => :mojave
    sha256 "0df34c6f8bab4409f41df39672456668d42b05233ad215d3987493b8008f7101" => :high_sierra
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
