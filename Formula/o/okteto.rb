class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.21.0.tar.gz"
  sha256 "bd52a0aba97299a60f485e56d31abb51675977f1cd94f3cb53a1f0df2b8f20f6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15423ea8d894508c4e68a1becb53464642c40add4d5c5f8a59a4e33aebb1a33b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe0946f69686368497c7890e7cba4403c252e8bb2ce5e4e921983ccd0eed8b29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e74f17ee74e6f80e33976a5a7b4b33f17de613d1b464dd2d71fbb6e2126fe4d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b53f4236fad7c274703be0a3a6ff8dbd012dc3ae7a5e55015c1a788fd5492dd"
    sha256 cellar: :any_skip_relocation, ventura:        "c31044eedd99c48016a5635dc0bf0b662991964728109554b12ebbd3b96e87b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d8ee75254507da94cf0f17277e655c755f6e347131c93cb7450caeb5ec33710c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f847404180de48d3768fb177e0822a7d41f96114efb47aa361179d89786a4e0"
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
