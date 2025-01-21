class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "af8e77ce08a8b7a61e80ca4866496d21e04f42dc90c0fb9fc31a457d517e345d"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f57a0ba86a32a9a240232fb1ef8f26ffb0decb8050f27ada709a1b3019260763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f57a0ba86a32a9a240232fb1ef8f26ffb0decb8050f27ada709a1b3019260763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f57a0ba86a32a9a240232fb1ef8f26ffb0decb8050f27ada709a1b3019260763"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa50225a8ea65ea068cef8b88f0a1c09fe71c97790c31980ca3f784b9627709"
    sha256 cellar: :any_skip_relocation, ventura:       "5fa50225a8ea65ea068cef8b88f0a1c09fe71c97790c31980ca3f784b9627709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9738fd6cc1a455157bc863c459d339717110ed78be559aa998e3bb55074c1e4d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
