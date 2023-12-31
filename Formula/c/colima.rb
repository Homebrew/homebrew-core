class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.7",
      revision: "ba1be00e9aec47f2c1ffdacfb7e428e465f0b58a"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3491af3bbefdf7924b9ba6730fb1bb2256fcc25ae3db6775b50c9c7d2ebf7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1ea2a2f3d8b06eba94a4ab7d00436fdb71518f758f5b40e8417ae2a62c20a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "146af3f77d478b9d270ba552574f0335229dd2f44e8fc82290882e9ea8741955"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c3ed6d58a6b5ee57b1c6cdf4b591b432dca751145e37a8c7122f73c20efb879"
    sha256 cellar: :any_skip_relocation, ventura:        "492dfb99539f9ce3aedf06884632e6d554bb95c45b5e5b07d1075a109cce7a39"
    sha256 cellar: :any_skip_relocation, monterey:       "ddab4591dbad8f38472e3b453dac35e316cf20767f78cdbd4a2e7ec02048742e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1b3021b9ab0ebeabd19b430f22762939328076607496e7170c37f8713068098"
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
