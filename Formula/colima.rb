class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.4",
      revision: "feef4176f56a7dea487d43689317a9d7fe9de27e"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bde6ac857fe458f6fb23c57059946a3cbf746edabb9448f988889d5f5c1a297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c309adaf842a70bad694a5cd0293aaaa346ae14b19dc021239a62c555ce2c947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c309adaf842a70bad694a5cd0293aaaa346ae14b19dc021239a62c555ce2c947"
    sha256 cellar: :any_skip_relocation, ventura:        "cd4dd2c9b0b6e5e927bfbbb814c4b54a16078354b9588ed70545bb31f444809b"
    sha256 cellar: :any_skip_relocation, monterey:       "61a93b82311163b2b73f9ace3a408428a7ac1a8c745012d56c7bb69f8ec084cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a93b82311163b2b73f9ace3a408428a7ac1a8c745012d56c7bb69f8ec084cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a684b14326fc01cc9a5d8b7b6321f9b3a00d0f9ed0d0d7cff98adf4b76400c"
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
