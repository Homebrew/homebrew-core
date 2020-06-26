class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.13.tar.gz"
  sha256 "7befb37276815995302b71efe3b6eaa684eaef2977cccc16348278542b481219"

  bottle do
    cellar :any_skip_relocation
    sha256 "63b8c7a3b0b22e077b3745af50b58869d4c99beaf2ab243122d4bfa812b4b04a" => :catalina
    sha256 "dec2429d9db81f3b891a15a0168404c643177d248f8e548439b1340851d916cb" => :mojave
    sha256 "5432f4349e4dee25f474ee3d691a4d3136c786d35131b74553c2c80e4010baf8" => :high_sierra
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
