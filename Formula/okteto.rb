class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.16.tar.gz"
  sha256 "bba1d4f9c67a764b8a1d2f99fad01494085f41351505baf3bead8e9d862d321f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "70a5bfed101fb1a1bf9d81582e37f5d608e341d9e0c2da582bdce2efe900f49e" => :catalina
    sha256 "46220febb4bf073f2ec1efd796ef78b18121f32d7b0660139dad7f175021544f" => :mojave
    sha256 "caf809748033ab5104d0d1bf6b21520684c1686eed8c10d84d8c98c4e5f0c43c" => :high_sierra
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
