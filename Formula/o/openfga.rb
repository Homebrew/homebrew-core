class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "44a66e65d9a09e63b4f6a3b761163e7c9687d3ed0213ae0c60f073757c10c3c3"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e6b177560b1c90990239dd8dd6846af8002d7726011c5c93ce29ccdd80762e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0520433267cea137906b50bfeda5ec7cbc57ae90796740141ef1aa1de30989e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9467863122de747ced1b22303834918ddf2ec0d2f1ac646d4310a8ad1cc1e14"
    sha256 cellar: :any_skip_relocation, sonoma:        "c32b769a7881c6943db1d3722c38dc6442788186bb1c3874173f26fef9de37fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d26e9c9fb7c6fd8f0c7baea96a9d0d0262a58d15da82dd34e1556b77a7ad371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac97cd0601895154876a0d3c51a80fbce41381e85c66715d82988bc632dd9d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
