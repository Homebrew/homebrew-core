class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.5",
      revision: "6251dc2c2c5d8197c356f0e402ad028945f0e830"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6934ad6a852b6dfef89d1c70f1054f57bb8d73829273d2bf2a81b54d40b209c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0b1bdcfebdc295778535b64a969c16525bada5b90cbd109bed950009b70404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f697f6f4c5fb1337a62e58633d8e59282b4c1cd0b5a5b65208beebf01b043946"
    sha256 cellar: :any_skip_relocation, ventura:        "f3053b8d36d66e0d203d07aa1204bf86e14fc5b8fccda0aac443ea05c0de7d55"
    sha256 cellar: :any_skip_relocation, monterey:       "42d0766e383e810f1ef211348c102f0fdb740b2379e576e1054efc93f2fff073"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d6ad19bca3d046d571798be1c0d2b8c5b7f1f18c89a368c008181f3681d271f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57362e532cd6000de79d535fc740b511ece5cf0f086276768a2b4abe18e03f8"
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

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
