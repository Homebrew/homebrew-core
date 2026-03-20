class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "c0cb64f7861e439ef13fa06845e7ab6b219364b7b083c7ff10d851e764e6b16b"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c728240925aac5e240bbfd48135870e20809d8a5757f43ad4ac90ff3631f90c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c728240925aac5e240bbfd48135870e20809d8a5757f43ad4ac90ff3631f90c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c728240925aac5e240bbfd48135870e20809d8a5757f43ad4ac90ff3631f90c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "275ff8591a04c6383cf79c18b63ca45423a0c8511d741768ab9c7adad16421c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1814cf229f4ab63a7fac063369dbf7636505fbb1efe2232ae0c70958b201040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de188c828e69621d3a851a581ba6703dd0d1ce4293080f7587699488b832dcc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
