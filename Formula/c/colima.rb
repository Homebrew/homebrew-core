class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.6",
      revision: "ceef812c32ab74a49df9f270e048e5dced85f932"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a93c9500e8856e8922a229d6efe1c30b8a87c5a5a385209c78ec47ad5741f91e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "395316409834bb486e49634de5093f7edbfe7fbb094b2eccbd25debb56e0b479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29cb6a4878bd86cd35e37438d11e27721961fdb63ba31665341e87f3922257a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f93b2c7658abc2b1e45924ceebc78b77270ea7f521fab4a0a13c3bf08993cb89"
    sha256 cellar: :any_skip_relocation, ventura:        "b7d75429b8a11c8b3e37805cabfda6ac96b91671eff2f489f813e1acd0e5f7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "955cc7911a0192a2cf37522553ae0fc0966a850c25bf9e3cea5d59e42adf5453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f95d492e0a24f9679450d8a9907567e7c360bf12592e3818e44b1de36b0e12"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

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
