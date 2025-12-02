class Gebug < Formula
  desc "Debug Dockerized Go applications better"
  homepage "https://github.com/moshebe/gebug"
  url "https://github.com/moshebe/gebug/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "3dac2b9b1f9a3d5fa8c19fceb7f77ea8ce003504239a2744bfc3c492b96a2e56"
  license "Apache-2.0"
  head "https://github.com/moshebe/gebug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3dd8c86eb0f4477d236cfc124fbc1e79bf3e3314013e09d0371fd767b50370ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8249adde26fad306299fda82d64cf21407588745684177b189d572b0a6444b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "312131ff1206ebcb33f39aeba602acff59393b5990f13e4b2e0cc0888359ee8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2af5ddd3ad9ce2496222ef20875a777fe323c1e3cc2e3d8e706c1ef439c8069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2af5ddd3ad9ce2496222ef20875a777fe323c1e3cc2e3d8e706c1ef439c8069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2af5ddd3ad9ce2496222ef20875a777fe323c1e3cc2e3d8e706c1ef439c8069"
    sha256 cellar: :any_skip_relocation, sonoma:         "e090b2958d2675a75d9a9acb3c7f9097ba545c901b393ed6fba60b3007915d81"
    sha256 cellar: :any_skip_relocation, ventura:        "c8480f6e58a565ae8fe846128699ffd3a8a3990277468ff89a3a0f9098c5dea4"
    sha256 cellar: :any_skip_relocation, monterey:       "c8480f6e58a565ae8fe846128699ffd3a8a3990277468ff89a3a0f9098c5dea4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8480f6e58a565ae8fe846128699ffd3a8a3990277468ff89a3a0f9098c5dea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "36f607990fbc237fe11cb9c3879ed288ad7c3b1dc780ff20689e3ad6560abfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1810e5b52e8f5f5c9829025e39111c452b3a474fdb171d535d74d9a8492d68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moshebe/gebug/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gebug", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    (testpath/".gebug/docker-compose.yml").write("")
    (testpath/".gebug/Dockerfile").write("")

    assert_match "Failed to perform clean up", shell_output("#{bin}/gebug clean 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/gebug version")
  end
end
