class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.10.1",
      revision: "ed905203afdbc6fd4eae6cc301918099ff31e86e"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9865870ba93a101fe9c8f17fa81d450c85785cb361032fe815e3843ff381fca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5143920a170aefc724abed27b28c374ec3950e23349d738fb781cfdf80993a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b182371df65d75abe3c957e28b45b05479bee6fe43cbe6aaf343f113dd9f2c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "96bdbbcd5c576144cc72e986496687afab490dbb1ec1a5841c5193ff61402bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14c24ce95b0a1462516cdedb0eb3f24c2cd05e471d43ae061f5127298e1d719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67be2c11436ea3f7466cda88688618732e4519c70a7a2adb7f46e2cb5cce444"
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
