class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.6.tar.gz"
  sha256 "93e36ed92a5f8f08971ad31d30f2a9dc149345c695b5401da0b1e923748c9e16"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f292b865ad2db24395732e60312fc38ceef78abd5d391349b76ebadeec8c5524" => :big_sur
    sha256 "316b74ec48e09269d05c9dfed5be4149a57287ecde39c920727eef564497ac02" => :catalina
    sha256 "898239f86ac05ceb51659cec9f2ca49dc024767df99794f63f45d60edd7c8020" => :mojave
    sha256 "1af2f94a1d178f194e82aa5524c9564a5cc67650123f5980206f073161b5fb57" => :high_sierra
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
