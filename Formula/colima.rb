class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.3",
      revision: "0f3f2de81518db18b70a83a83936fefc6b4706dc"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4ade25de36986bdc514d90ff091638fe5797c3603b76173080109986295db11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e07e057afdcc05b6dc4a4ac58ff19a89f1561e5f922bbfa45456a033ae63e70b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4979ab219d11cb0e5d6b8c1787679ee6da3c88b875fb3f80173b1f42022d27c"
    sha256 cellar: :any_skip_relocation, ventura:        "f5390dbd17ffb7c20d8868c9699b584ab9f00b3558184ffeaa450d12368697e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d84c79bfdff2a9485f53e408241c00c7ca9d98425fbda97347928c1db7fee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c4349326d2c021175ad8c0d0f845539060c6efd707d00be68b0d05e6f23bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d8068df862a13166132196d3db51e144f3c45ecae29864dcd6d911e4a89d07"
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
