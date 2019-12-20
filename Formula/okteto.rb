class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.6.2.tar.gz"
  sha256 "86c854ea11cfdbc91864414e4e5a1f2a8a0cc77fd58ba550d7beab7db7f5ada8"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f94926bd7b7f90c30e12c02331ee36dca834b1b7242c358b1650ae127108f05" => :catalina
    sha256 "a4ff8ad8b906c8bdc68e8ab05847e3e57478f8571e26d81def9af8def8f5f52f" => :mojave
    sha256 "b1532ea90c7e24c6ab965680e1859ec4c118a70971c2c0c92b76f3a70787904b" => :high_sierra
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
