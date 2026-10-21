class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.77.0.tar.gz"
  sha256 "bca8aeb766be2df346af72d82b84918872a69afc05c9a7d312040e216985ca3d"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f778717cd6fc234b47f7c29b33e9db5c500b95459d0c3792c647466a54a05134"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f778717cd6fc234b47f7c29b33e9db5c500b95459d0c3792c647466a54a05134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f778717cd6fc234b47f7c29b33e9db5c500b95459d0c3792c647466a54a05134"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d54e5b20ab552e1e705b683f1e868bc7f2ce91e3f0bd9290a6843ebbb914c68"
    sha256 cellar: :any,                 x86_64_linux:      "f014c5286460aa416459323aa6078a2cf5a9c4e4cdb77970acbb6f4cbdafc939"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
