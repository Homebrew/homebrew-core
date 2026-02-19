class Gebug < Formula
  desc "Debug Dockerized Go applications better"
  homepage "https://github.com/moshebe/gebug"
  url "https://github.com/moshebe/gebug/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "3dac2b9b1f9a3d5fa8c19fceb7f77ea8ce003504239a2744bfc3c492b96a2e56"
  license "Apache-2.0"
  head "https://github.com/moshebe/gebug.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e4d6f729ca5b8587e2b444e3a4f8f75f1cb6dcb8561f5b40c0f06aa2bb84513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4d6f729ca5b8587e2b444e3a4f8f75f1cb6dcb8561f5b40c0f06aa2bb84513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4d6f729ca5b8587e2b444e3a4f8f75f1cb6dcb8561f5b40c0f06aa2bb84513"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfc58de4fccfcf5fd5bd95abdf39711c8be7604a533ac96b2b979dba1631598"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0bdb92d2b744c85b4b0dd0dc5846b0517716ce8edf62fb2503803e72acb0e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db711bf46b680fb8cc9281aca1be97b803ac9ea2fe3734f1b736fec989c074c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moshebe/gebug/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gebug", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    (testpath/".gebug/docker-compose.yml").write("")
    (testpath/".gebug/Dockerfile").write("")

    assert_match "Failed to perform clean up", shell_output("#{bin}/gebug clean 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/gebug version")
  end
end
