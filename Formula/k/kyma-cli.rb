class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/2.20.5.tar.gz"
  sha256 "6c39252cc15aeb4828831d040819297c9cd7a5235844ae9c9ea91dad8db02551"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8e2908d074bedcae0b73a8279a6c3856d0a6bc2234dd20adabc3abe2dd47d352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bff4fcdeda28c0ff582c34aa30ee171319b4478b9d6af175d949d525c6cbf5d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f4d62bc61545db83c20e731e14ed0de8d35856f88bc9d0f3ae2008f6c72f8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5193a6b23e406ef87e9c6829e63de28888199ffdbe5bff65dec95bd9e87e07b"
    sha256 cellar: :any_skip_relocation, sonoma:         "51ea7ae1f069f4ae9b80044ba461c314c5c8e68b1fbbcb1dfb4ab03c2aa160ed"
    sha256 cellar: :any_skip_relocation, ventura:        "6ee34b3498729c5069494b95b08a589d4468834a2001c17e45131ed2ce53e647"
    sha256 cellar: :any_skip_relocation, monterey:       "adafe8dcaf3bf488a2df29c7e92647fb45f097f3c532b78d7a60074a49bc60e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb2e46ef5d6cb0ca12ae214815c9c40b6e233f403a0574f4833df8d413ff37c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end
