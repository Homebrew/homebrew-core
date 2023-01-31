class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.12.0.tar.gz"
  sha256 "fddbef4d32a6ffe107c8b1518781446a3d75ae78c289f42ee1860e13e1a4a450"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29350af66f7a72c17a7fb42cdafe290125a462f7a445f8a1ec5f20c021b2c6f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ab9777c1db22b05cb2c1cf404e4e9a1deccd35504ad03775179fc643270def1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce70e80d33b0f6f5f5bd572b639b9c3cc502336011f17e6063c12ed4d9bacf8"
    sha256 cellar: :any_skip_relocation, ventura:        "05fdc6d376a6d46c77af7ea4ec71d36d53ac23ed81ac8f367143a5639b9f3bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "71b4b0ead7139be4aa3959cb450103fc94d34d5bcc3626085ff323330916fbe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "74cc3a012bb1fe7c5d5ac954dc400b3a2a6284c6775d59d08f8d218c108a6081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5535c1b5f91595ee70303a22543aeb6a29314ebdacc963fa6ec51b6a4b7651"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
