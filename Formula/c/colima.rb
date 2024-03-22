class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.8",
      revision: "9b0809d0ed9ad3ff1e57c405f27324e6298ca04f"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69af395c2207b9e0b9c917cdff036b3e2b968053a1a8b697cccb0bc6a59f66b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e04bcd85149c81b9f62bcd80335a339fabf549b2aebb26f83826c7435fd6588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca657354e115efd4a01314826d155b19e8c4c19c8a7f7cfd8882cb7437dd0958"
    sha256 cellar: :any_skip_relocation, sonoma:         "15b1c66cf3bbd045a31c78dcaac9e98a70da4d68ad37de9c17eacd399a32a5fd"
    sha256 cellar: :any_skip_relocation, ventura:        "b9869d62c575a6448bf9ce5e398b99d53f528bb9d2fb6c247057fa4b7b25cb8a"
    sha256 cellar: :any_skip_relocation, monterey:       "19f16a9e1965a239c816566d8d252fb8ab279f9dafde346549a8c937637d91aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3fd98e858d8f8f8092d01525db71e837670f25439b0e1373581cce7ce8b231"
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
