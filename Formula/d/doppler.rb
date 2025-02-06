class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.72.0.tar.gz"
  sha256 "6489f31222ae5c9a5a81d98685563c1bed1ea8da83948015ee2e2d1e58fe630e"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80eb45ea9c15cd4fae4f71ea7e2a8dd2a1c562598099f0db3597564c9264f22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80eb45ea9c15cd4fae4f71ea7e2a8dd2a1c562598099f0db3597564c9264f22a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80eb45ea9c15cd4fae4f71ea7e2a8dd2a1c562598099f0db3597564c9264f22a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c433c9ecd9f8066fb25b1a8d55fee457e6b5c8b1b52e738b03603bfe752f405"
    sha256 cellar: :any_skip_relocation, ventura:       "1c433c9ecd9f8066fb25b1a8d55fee457e6b5c8b1b52e738b03603bfe752f405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681caa3d57e13f6d2af78d514f1f4a6f2b562f08687026b2f296745165d19ff4"
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
