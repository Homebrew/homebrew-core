class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.5.tar.gz"
  sha256 "9baf554dd0dab354fde9c7e346ed1f0dbad26cc75108200d038cc57e535e6e32"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88b428a1355ddb7974b92532002f0b1e42e5ad1265dba0fc21fb76832ae2223a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7686dbbb1300c3e13570bb2b11b1e3733c92a9b3d2a5ea33cc35f6fcd304aa6"
    sha256 cellar: :any_skip_relocation, catalina:      "604ce895dfd67e25a04f812566cd9da2ffa196690d57cd9a10a7033cef469017"
    sha256 cellar: :any_skip_relocation, mojave:        "beed1d37aadf102104b0a33adb465c7c0efd4a5c99af893b59aed551dfa63a1f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
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
