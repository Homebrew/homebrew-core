class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.10.0",
      revision: "7f5f27de13d921e66e3a78de0a838ddec581871a"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e1f35ee168b396f58856c7d5528ede4148bb261c67db252783116b916b6a3df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98b919913d8f2492c7e80428af156f8c3c7cb3bc633317fa18df0322da0a139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33bedb225dfeaaa744fb52ffa8ae6a2ca12bc3a9789e210e531de31c31d05062"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ef280820846ffcf2748f0388782efced43738fda731e5238eeed71b9d0d278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e83e6a4aa7453944dca7800dc68269f544f70d35d8da847c4797f4de758bfb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc531333de837bfab49f13b00ea8cae054846e6dddd4cee4b8ad2c1f1b77b15b"
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
