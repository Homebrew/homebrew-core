class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.8.4",
      revision: "e2ddc15483af66e9b8a525d779a0cc926f15dbcb"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a628d22f5335221f962a1618ac5e2837057ef0716de0952a9fe63e0a2f148d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dd80b243b8ea502c1974803d55d1901d52382c75996fec7a1ddaa5ecd177dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0160d937f36977860762da5ebb5cc9c924bc547f65724e59a001110380c30d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d04f8b7598819cc71b7d0850272e27115a1c0b96290e9eba3fbb583520d44cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a43c569866e03cd89d090149dbd232353969727bda17481c80a39beedb3ceaca"
    sha256 cellar: :any_skip_relocation, ventura:       "9bf41a78d07184eb0a379ec62f9fda3de8939452d8f1376f1e7c9ce1a4e2d6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdc44f0cb18671580868f4eac1f4d1d1ff2716bdeb23e77d70811a4c008676f"
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
