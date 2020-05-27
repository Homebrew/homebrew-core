class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.9.tar.gz"
  sha256 "7a840ca80f5c445607d93b5d3203c6130b8b28167f6adbc223337b3d9e1985e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "1741dc9f4bc1ffd79a3c4553f9864d0e1e64fe61f6b6cf8d55fcaabf477c0bea" => :catalina
    sha256 "cb144f2a9c179f46bc5efd1f60b3bb17484d3eb289fcded8936d15f5df90a921" => :mojave
    sha256 "325782b7e6b9f71f4fd4cfb07e592a92a77757a6756c44a56220ed611bdfe1fc" => :high_sierra
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
