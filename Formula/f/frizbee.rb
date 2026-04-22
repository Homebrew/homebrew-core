class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "e52ccdd77b3c6c71bf4b38163df451b550beda279643b071eae9df96b53a455e"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07c65e819a36178726e14a5c1dfd614c54c3471cf1a88e2d4e885c2022520cf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c65e819a36178726e14a5c1dfd614c54c3471cf1a88e2d4e885c2022520cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c65e819a36178726e14a5c1dfd614c54c3471cf1a88e2d4e885c2022520cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a768bb4744e281e1c04147c9e858d71a736f0ac25fb30f7d04b567accb36f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faed5b12b9b9520de98d4e29626443aaa7dbe7fa94f04fe64918943cd0e2d988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4bbec3f991158720335c1566a0e43d9741d0f1ef1205c9aefca50aaffa46267"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
