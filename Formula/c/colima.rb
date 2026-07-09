class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://colima.run"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.10.3",
      revision: "00f6c297e92a82c04a4ab507db0a61435650d7e8"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9dfd1fa0a4aee62fef75974f39f174e4da774f7ba495c43dd0bcc23633381b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ea218ab2b408e940c4d690a547c082b5be3cd3cf581ddbfe0f3a0166434ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ad2203b00fde63c5060b236277fcb8e041b8e78f325efc433b701a55a881c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "47bdc2c0e4c973fd07e0855800aca386d77db7d22063069210e32a5169e76209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49146e4d5b549033572324cc922404cd783951c11d725a31c8cdea1d38bd1aa0"
    sha256 cellar: :any,                 x86_64_linux:  "e97b386468c0b511c53253c31a5f34cbfdf7bb976a5db656bcf31ebe90edbe63"
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
