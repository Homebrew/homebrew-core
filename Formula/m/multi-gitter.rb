class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "82cbb58888eeba869702ea60b508d964e093da3b14beb5bf1b93e9cd5aa013f1"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d05ff0240f138a63673f450ffdeed76334356e3a48c6b20d702e7065edc59e96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d05ff0240f138a63673f450ffdeed76334356e3a48c6b20d702e7065edc59e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d05ff0240f138a63673f450ffdeed76334356e3a48c6b20d702e7065edc59e96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a051f1c67488855ccbae81d9a6fe5919eb0f7b50c7c42a087fca51296deafd4a"
    sha256 cellar: :any,                 x86_64_linux:      "5a66fb4f8232f7fc7014eeb308bb6df4ff3680149380edb8891cf61af38ca987"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"multi-gitter", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
