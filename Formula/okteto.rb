class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.2.tar.gz"
  sha256 "432443891ef05e03c9456051e1c0fe9c8e9d875b63f1f4af70a237d662111a1c"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "465b288730b4047a1f9c79137b46e8a951125de63fdf6d925c27f6e80aeb3a88"
    sha256 cellar: :any_skip_relocation, big_sur:       "3112361c3f62ed29c7c0fff6c53e812683b7c0afc8b9833fed37e1489abf1ab8"
    sha256 cellar: :any_skip_relocation, catalina:      "352dc881b3bfa09347b62b5570555b948625c98adc4df501b2e9fbd02996d04d"
    sha256 cellar: :any_skip_relocation, mojave:        "4a821e7549aa89a67cd6eba2461e2afa34f4413ceac164397bb6c0ae9e65ea53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95457c0accc78664d5a00372ff64557ac402297fccae9c6c47f9a316a89c1f92"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
