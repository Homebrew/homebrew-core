class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.8.tar.gz"
  sha256 "ec56acb7b514f1bfa446f513196639c9323dd76f60bdbf312b50da7846096ed6"

  bottle do
    cellar :any_skip_relocation
    sha256 "74ea69544b628ae1466ce322e45fea41f8730d15ed4ee2835ccb8c15bb2791e8" => :catalina
    sha256 "da83b3ba101b7093ce6f76ad5cc0cbaddda17957ca1d0c89e91ab7037488d365" => :mojave
    sha256 "d4ec9d3eab713132b8016386af3ac7d69e511992c0c2e9d28fa1ac00e8571fb3" => :high_sierra
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
