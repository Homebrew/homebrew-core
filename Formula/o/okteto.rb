class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.0.0.tar.gz"
  sha256 "f8ce1063b4e5d6168c7d2dca83860d0c29d07c058f93b0f3ab5854805c6d7a42"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f13317dd8fdf87f9740c26c80c8b88b05d84b775cd768a330ca42d71bb5e06c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a961ad575c3d233ace6a4129bcf58771f41bb0ccb3630c2839ed394016eb4d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d41479fe4dbc627854989ef1e845b466b6f2dd8165f3d95e976187ebeb3c265"
    sha256 cellar: :any_skip_relocation, sonoma:        "122be615c906e02cb87e7eba7d09238b9df8a976bc3669eb2813e592da1cb0fa"
    sha256 cellar: :any_skip_relocation, ventura:       "bad42bd0919f503e11561d8a8bced4e979141e84917cb9d967275ed80a5b25c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2deba58b1129790debcd179a1d531a5e96786b9ef1d2cfd7b060374731a404"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
