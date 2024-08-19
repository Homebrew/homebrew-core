class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.7.3",
      revision: "a66b375e8df84ff2860797efc683e66632bcbce3"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c76929d147b2647a545e82749c9c8b38b08feed3f5f84586cfa6e37d353fd85b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13babf0763f644967111e93d869e046323e30c95eb74f8446cc434fcbe1b43e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6d5c4a5cc0e9a6c08d79e9e35018ee7cf9258bbcb1b49edd2d7e04d1c91a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea612e9ae2f459964b51398b0c6c0f625a4e8de2c5c418a242166f0ce0cdfbc5"
    sha256 cellar: :any_skip_relocation, ventura:        "ad45709ed80750952cef86c23ba9339ed018c903bca4d63cb5c5edcd646f7d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "7985b038ecbf4951351457d6640a2c9c38a2ab2f91e029198d32713df9e0341b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63dab9c7d481510bea223da37661ff5990dca17ac76fda7f576b26a9cd243457"
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

    generate_completions_from_executable(bin/"colima", "completion")
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
