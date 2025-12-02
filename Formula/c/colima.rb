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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a7f242382c46be1f99eddc585491ea078110f1e6e9e07b7f1f12fd0dd2460bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7625efabf5dfe6080f76b2af352aabe20a0722b9884d8f5b14bc4a9f5ab586eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd91649e2535ca35ea4f40beac828631a028e9e5e7a869df3ae7a124100e61b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcd7375b90de4cf308fcb89f7a542fd947b43e4703eb4c268c7b75f7e0003524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5314fdeb1945dd23572eb317918b1a11c62452bcbe23e0d7270a5a67abea38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba50c768eb2d2f6cccec94cf3d784aad48848dd9544ee7a25a7a1be269e22f8"
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
