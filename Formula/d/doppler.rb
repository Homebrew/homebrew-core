class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.68.0.tar.gz"
  sha256 "dd08dbcca9bb3bf0f08f68038544b0a89f557e714c816a14e2f10fffd9016071"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa5a63dc80bb40c48e2553c28a6d212d504ead6da77032a84969d2561b19d785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a04339e51e6147e102bd2a440838216de0b4204b0ca592ead42c4381c68a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3aaa334f3bde00a57551c3dd8f4cc5039990803013d0dd0f868a2ac4524b83"
    sha256 cellar: :any_skip_relocation, sonoma:         "97c5e7604988344c7202c50a8190b26c91a05a779ddb6af5475d7d3b019fa2c8"
    sha256 cellar: :any_skip_relocation, ventura:        "b848d4d5b25fea185d28f84116f46dbbc356d1295b7dfbdc7ad62d425b62dd90"
    sha256 cellar: :any_skip_relocation, monterey:       "984c2afa2d55a03dac7bba52552a46f93e44f057392a64eefa5732d376be691d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f9f5faa5e68505753e4eef7b67930310e6a2eaf3cbf90eedd89aca539e36d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
