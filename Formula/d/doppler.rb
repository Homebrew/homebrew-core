class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.76.1.tar.gz"
  sha256 "ea645c8ddd90f54255bcfb936d892681532c4ecdd7b538b000fd90662ddfaeba"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2a580fa62640c7af72f904efe423e2af4fdbf3386fc1721f06695845b609054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a580fa62640c7af72f904efe423e2af4fdbf3386fc1721f06695845b609054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a580fa62640c7af72f904efe423e2af4fdbf3386fc1721f06695845b609054"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d83504ac3a4fbb6de2e071dcd4d83695297be44fcce8258e40c95a7a89b349b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9013724292e44225a00155e3bd42e9fefe573c55c7a949497e22308e9a1e5abf"
    sha256 cellar: :any,                 x86_64_linux:  "3aa3d9c7df01b36e87868a1e89d3763ff9c0b1533169e5a0dbc4f1fdc47a9cfd"
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
