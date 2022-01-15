class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.3.2",
      revision: "272db4732b90390232ed9bdba955877f46a50552"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e9eeef734397b5460f46f9897c4dfb42db5534104ebde7f5bc2ccaa7fdfbfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e98720829f6790871bef25ff349ce08d5e3c3b9c5faa7e2f4b71b5a98e349d"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d0b85e2b0bd568d09c13cc11a10f758cf8a6cbc3c9c45b0caaa17c9b4b68ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "23c50d13164d385b6c7f877911c814d6580942c26fbee8001a805103a2798682"
    sha256 cellar: :any_skip_relocation, catalina:       "201472ba5ae47dfcb8ee38deb08d915453b40bfac97a78e40ce1623acb6182cf"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on :macos

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    (bash_completion/"colima").write Utils.safe_popen_read(bin/"colima", "completion", "bash")
    (zsh_completion/"_colima").write Utils.safe_popen_read(bin/"colima", "completion", "zsh")
    (fish_completion/"colima.fish").write Utils.safe_popen_read(bin/"colima", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
