class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.7.5",
      revision: "1588c066b9ab9dae8205ef265929c7eb43dca473"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c8cdb869f646db7996b5a263bf5978643e9f45655ca4ccf8f30542784bb57976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "242c7c1809ab130b98d733c0b1946a3d9bd3ba2a8f35d5afea40ab0e6643d9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67719382d40b4dee1a533514eb7279f5a86e06f3b59e67413641ea70a7daf422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55c06b79523173903927ef480982bfc7c486c05f8e9ecc37f0f324ba8fb3e47e"
    sha256 cellar: :any_skip_relocation, sonoma:         "52eb4c4316c2349e71286cc46a8862c72428d25750859469267a98f06217b4fe"
    sha256 cellar: :any_skip_relocation, ventura:        "f1fab4f9e288f0f45d76efc4c2b51f9deaa380c944a9b19928ae5bc650bb82bc"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ec6222ee128185f47dacba778a70c43e2796670ac05bc6484b9323a34ef7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee56290845222d178030eb437216a950a8a2a285b81138ee688022230734721"
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
