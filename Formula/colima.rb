class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.6",
      revision: "10377f3a20c2b0f7196ad5944264b69f048a3d40"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35150d30c06a4c5e20a4d657eb77732d170acd188af33ff3e18071ff5b1e1ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eda2f83a37b2cccc8cbeedf569f34be1bff2b824312d7ef246038b1c1ba81f88"
    sha256 cellar: :any_skip_relocation, monterey:       "87f1691b194d350cb990cc9b736095c51bfc6af835829990cea7aaae3ac580f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "50aed168a4535070271615b7515bfd57732c008aaf86a3413aaea3ef882403bd"
    sha256 cellar: :any_skip_relocation, catalina:       "da6fbced11a4a9b0601bb900718bd9c340943abad2875cdb35b175803a8701c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9b638131065532666f6f443164de6972dcbefb8b01c5687ee854a2c5b33a3e"
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
