class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f0f93393529c403bacecff67e7c77a73ad9795fbbe46b1c2a3b421a7f53e8578"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67afe457a1fff0bd8e1c621cb84872f49e1de22668a236c7d0883513244bd409"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55b807ccab18ed58e0d1f67af715eb12915ddf2544f0ea67f0ca32813ba54cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4becf00ecbe6d2ba80b2a3eb912220581154612b046df57ed1aaef292a190a54"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcc9944a293816fa258b89810f669637386f58f3fc943b1a6d00e542aae0a32a"
    sha256 cellar: :any_skip_relocation, ventura:        "e71d6d7482a16f4a01de2013fe9d15f9857b09606cd8c05d6e1ffcc127841b54"
    sha256 cellar: :any_skip_relocation, monterey:       "6a27725ea0c787e5b715d4509f73061cd1722ddaaa791eafe113c6e996a24793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f6cfb59aa48961665e0543913fe5eca11f922ffa17e3c0cdfbb73c7e6f25cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
