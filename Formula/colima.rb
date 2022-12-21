class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.1",
      revision: "fc2ffc3175aa073ba724eb491ec851a154b894da"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0060374b54b103dd5eab7f5a46d3b085cd1afb653d4b7d10b12bbe846546b840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c8b3bf12e51d16bbb598955eac7dfcd52f22e1bba02688267f8529a498d872"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29d2a3364bc5518086bb6864b640338663ac9f8e4c9a6b0c15f4ab030b860489"
    sha256 cellar: :any_skip_relocation, ventura:        "527d350e36f3509e45b62eac3a43f2a34fcd2f9da832dc2d7180ec1dce820d69"
    sha256 cellar: :any_skip_relocation, monterey:       "465d8338a2efcb7ae00abf7dcd06de384691b0fd1eaccaaeb7d66a0a8b4b3215"
    sha256 cellar: :any_skip_relocation, big_sur:        "767c5d3c6d732a9b7b57e460712ec22c9a8118353bbd88f9738103926f6b9746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2da8e2f0578dd55e2f3a8bf0d22bd4a748524e5260bc33e05026c61d7d499e8"
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
