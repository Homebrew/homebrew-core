class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.10.tar.gz"
  sha256 "9014d24eec13f10558fef441103e106455efa0f57b111861f7c97fdef8337f1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb023060965faafbc9de4bc43f16cd2de5602d04a9a7406526d6034bbf496dc2" => :catalina
    sha256 "e6a2ccd38a461dea692eba928e5efdc7962cd01c9f99f1dcd876f0644454d971" => :mojave
    sha256 "fbec3c679310478aeb634ea580eed8d395efe0760c5d6bbea64a05c09020f1fb" => :high_sierra
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
