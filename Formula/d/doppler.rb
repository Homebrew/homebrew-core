class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.69.1.tar.gz"
  sha256 "f74713011f868d4069ed730a8b9c87572ddafe4b590d62aa13b8cc2903463cde"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2c21a8e2e3283b8b6e2381526103f01aed6cd972efdd24cabd28eedc59a09c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c21a8e2e3283b8b6e2381526103f01aed6cd972efdd24cabd28eedc59a09c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c21a8e2e3283b8b6e2381526103f01aed6cd972efdd24cabd28eedc59a09c27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c21a8e2e3283b8b6e2381526103f01aed6cd972efdd24cabd28eedc59a09c27"
    sha256 cellar: :any_skip_relocation, sonoma:         "4baf71f38517a9b695511cf1a7a819430505017b901e7cd9a033913dd017e60a"
    sha256 cellar: :any_skip_relocation, ventura:        "4baf71f38517a9b695511cf1a7a819430505017b901e7cd9a033913dd017e60a"
    sha256 cellar: :any_skip_relocation, monterey:       "4baf71f38517a9b695511cf1a7a819430505017b901e7cd9a033913dd017e60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2739d1c7e4b46737121725dcabc8c0a0e9983df079797afe790c7103437032bf"
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
