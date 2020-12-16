class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.2.tar.gz"
  sha256 "3ac74548a481d0416c0a46c223800057c5685327462fb34f81bf07d6621b589e"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e738709da64dd326f61ffac40a73da039ff939d5f479ffc4f1d35033ca29cb5" => :big_sur
    sha256 "58c58e0d99c35d560f4c9c7faaaaebf89a47a13909217687a902720074da91db" => :catalina
    sha256 "43c0794876b2e73305d14447c833d3ceaa6a4a19ac733c9bdd99e54f59448269" => :mojave
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
