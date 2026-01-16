class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.9.1",
      revision: "0cbf719f5409ce04b9f0607b681c005d2ff7d94a"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07fe7cb470fbc19ca9397ed2d70395568290db09ac1f6fc90b9826901f5092bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2ab691c2d3ad9d783566b9c84b7c3805cd2520c3a06c7123d9a5209f4afc7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0e52df410904a565cb50a77e66d5a55775a156970a4134cf3c8baf20b3a451"
    sha256 cellar: :any_skip_relocation, sonoma:        "b725a6f9b340d9dd4aca8a3fea932ccf416eb3f27a71052c8a349fbdb4576b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b96615720d89b7bbc35492fa556f738a4542fe39d9ede596e82014f4134594c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9bb263e4a5d0dfcb9a62c28fe553e231bbf44a469f07cdf7a3d92d1a1b0dbce"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -s -w
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"colima", "start", "-f"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/colima.log"
    log_path var/"log/colima.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
