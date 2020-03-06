class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.0.tar.gz"
  sha256 "5fe146bf15dd406768df9cf9c0dea35e2b5dcde0a1a42a7e7e5678f8ff8ea112"

  bottle do
    cellar :any_skip_relocation
    sha256 "2083c8dd7f416b2e1237bf3166c56d04e875dc6e21f5039462ba238e2b2a7336" => :catalina
    sha256 "02f0f8424fc33ea1ef3528da21a1b6fa116660112161b3d58d0191c7e55c2abd" => :mojave
    sha256 "56d9cb3875a23daede5fce9f106eb324d21700f54fcb637ce976cefcca94949f" => :high_sierra
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
