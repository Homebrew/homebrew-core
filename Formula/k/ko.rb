class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/v0.14.1.tar.gz"
  sha256 "a0621b2d6a2a3fbdad3627088b0edc5c67c13767a55050cb7e4c87bd597833bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beb1ee324e611b2e0d7f15f7bee20898574cf54668d9dbf1cfa9f4642548fbc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb1ee324e611b2e0d7f15f7bee20898574cf54668d9dbf1cfa9f4642548fbc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beb1ee324e611b2e0d7f15f7bee20898574cf54668d9dbf1cfa9f4642548fbc2"
    sha256 cellar: :any_skip_relocation, ventura:        "412d7c615d05ebe5ba08f61e91cc8ff930389344afc4c48ec794c849b30ee2a9"
    sha256 cellar: :any_skip_relocation, monterey:       "412d7c615d05ebe5ba08f61e91cc8ff930389344afc4c48ec794c849b30ee2a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "412d7c615d05ebe5ba08f61e91cc8ff930389344afc4c48ec794c849b30ee2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7704424382fa7525a1a5f651bcc6f6db403f9c274ee68e911df932716f4ca0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
