class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.8.2.tar.gz"
  sha256 "984bb75391e325be089adb1110ecfcf1c7065087c10c8fa6c4c91de26ebe853a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa222e800519f55f53ca65fc43262c8bf389ffe51b954464eefd6b97b12bd8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65a5e3329f351f72e664c6fd6f94b636f8accaaa60e94b0e5302244b284478a6"
    sha256 cellar: :any_skip_relocation, monterey:       "e13b9a0c0f05cc39291b5e2ef6a773f3139941b33108d8aa76b276990f6a1eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "464a59df9f5b6863aae07b937b7c2ad369ceaf21c4013d0199ccffb16b06f187"
    sha256 cellar: :any_skip_relocation, catalina:       "d33bfe27594dd9911d55af04ac6f5b085a2a2457c6b2b213441faa6ef8518e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183d39264b354c55a4f900ce1db18d8f42e1de56aae5237f559ea1381bad119c"
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
