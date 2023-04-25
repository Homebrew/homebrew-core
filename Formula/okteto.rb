class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.15.0.tar.gz"
  sha256 "688efafe2e2e03b98e6c195ef6631613203a5f7a664c517026bd6b6325df69e5"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1693685afb1902da69de84448bece637f2df1c24fd7e0c78a1b93dddd8c2ff54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc286817f742f8752f71559632f72bf9b8f5e9f1520f7dd4f2bcadf82a4c8810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "214e70a06d38f34fa10d6125115fa4ab25f566d29ef52f006c0d161cbe057c02"
    sha256 cellar: :any_skip_relocation, ventura:        "49ce98071d5142431ce1b0584b1ac8e8d29abcde58de4128c14a2acf18af5389"
    sha256 cellar: :any_skip_relocation, monterey:       "72d311385d3b2abdb2a5de12e579e6ad38b0a391ac5bfe7aed30e19946ea7544"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a02b3cb4b2096582fe98f366408347800902d43460edc014ad9119df567faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4e52c670829f1f29037a09d4b5ccd8e9f094e6cf25c2aecb9de3480d78d187"
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
