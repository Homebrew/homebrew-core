class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.2",
      revision: "6b5b6fe0540e708f0c9d6e8919fab292c671fc72"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba67ae748927b4b9c5308ce021c0a37ef1b724275446840f3b0fd1fd9fc90e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f550554789f2c861bf2ecfe821c8592a0b6251dbea925016193302cc920d60e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6cdfc0feeb51c26fe082316a44cf42aae115fe91f160227fb685521f308b516"
    sha256 cellar: :any_skip_relocation, ventura:        "dda85b88aa79522167bdd0da49fc02868bc642755f8c66ee02cb0f3e5a76bbb0"
    sha256 cellar: :any_skip_relocation, monterey:       "f6e25d74cd8f879b4eea097037fe16ac053f56f365afe2ee509ec6d84003cacf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c11211eb326c92923e17a6a5685c5ed369d037f9f98ed29d56bd3af8db91739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c20b6c6d7fe4f0acce1ed8fe3096a21d7f7e34e62e7b3f692b7af4b5de9862"
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
