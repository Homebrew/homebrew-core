class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.9",
      revision: "c3a31ed05f5fab8b2cdbae835198e8fb1717fd0f"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e447133da8bb1b996e5e3218c6b431fd4f8ad0cf560d9db32e999ef5ee118b89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2236bcb773bf7f73eb11fa691d278489b1d6aad95f0f08995ed95c32b13f0d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1db51ef01c669d30c0d715f21233a5cb5b70e93a485846c9b5ea7c4665ac99cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9098eb73cd255cf504f6e98ea0f66b943214415193cacdd2124d6bca7d3c33b"
    sha256 cellar: :any_skip_relocation, ventura:        "39bf3637aa37151027559463dfadf370bbb82648aa07844daf9eb0f7dd87e58a"
    sha256 cellar: :any_skip_relocation, monterey:       "85a2714b723ac062b26c6587e356fb1bd53bda5f112cfcab1633cded59c6482c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3ca203fffb978f2f2d72f35309ab583f01484ca3cfc5bae0a96dc40e89bf9f2"
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
