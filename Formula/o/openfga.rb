class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "8ffe3b56a872339672a676e9d8a701f16835b9c6d2df0e2c97edf37b6cd2ab09"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dde9da3dec2f814723c566ade9dc65b2d8669fdf29179ff28979924d0130304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c1fc0f48a340f06c6a37ca5720df10385e729ceaba40d50b89751b6027f77b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "088a56bb51574cba5afaa6a27265fc971fe39912ea025a3a9eedb45175cc5793"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1057747d696f8271d40cb288dd44dcb307d0dac60922db3cc35086d55584210b"
    sha256 cellar: :any_skip_relocation, sonoma:        "301933b85b644c3d1a32523e72083a5207a755da319034434c63be4916ba2b42"
    sha256 cellar: :any_skip_relocation, ventura:       "25f9ec93404b3d9ebd03fdd2277600d5b99d431f54f8cfc4916da3e50c12b1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e80a34987a836839db2bf0e0f3c93483d616ffd2447827f8ac14d4cdf466a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
