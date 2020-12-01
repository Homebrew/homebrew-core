class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.1.tar.gz"
  sha256 "6ac0a81df0c4ba0ea1154261b5772cd4cbae5e800ad5ecff32bba07cf6fabe9a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43fd9430bb6da4eed008d9dfa6ef388c8e381b6c86f110b75ee651e3e5ea2945" => :big_sur
    sha256 "088cb16f7597d509b3f63724da1fb28919b1262bf1b358bdaedabc7c4c93b2df" => :catalina
    sha256 "e0b83e2d3f75ebdf4157b5c7c7203a15885e3493de8af48c5ce6601b2c256c0d" => :mojave
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
