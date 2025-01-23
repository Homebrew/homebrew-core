class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.8.1",
      revision: "96598cc5b64e5e9e1e64891642b91edc8ac49d16"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8601f3bf93ac2f20626a12f4d068cddec17a742b43baba7f51083457fd7b16f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc95ca149e76289730810f8a336afceef043a81b8831d4ab1d4747189e7973c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7be1109ae77f76148c8520fcdfc4b1b391d0ce6508e2d2befc1458c40259f6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "50adcb716f3c2709df01409e6f6d337219935882fe07e95bd17410066dd5af59"
    sha256 cellar: :any_skip_relocation, ventura:       "d92924d1e207780a5ae559f2949a9a5cdb6620ab6edefe9d659e92c51696b0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b97ac7a0e415387837cb91ec365186722ab18ce5d3f1e9ef01819c07a3f9e90"
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
