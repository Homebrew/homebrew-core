class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "3751eb590950283c6443d068dab183556f1f827cc44a1709a98df68d513eca02"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad06c4a237fd15e58aec7bc5aa809bff4d73d9e2fcd8e6e3cb391c6062dda66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cad06c4a237fd15e58aec7bc5aa809bff4d73d9e2fcd8e6e3cb391c6062dda66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad06c4a237fd15e58aec7bc5aa809bff4d73d9e2fcd8e6e3cb391c6062dda66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cad06c4a237fd15e58aec7bc5aa809bff4d73d9e2fcd8e6e3cb391c6062dda66"
    sha256 cellar: :any_skip_relocation, sonoma:        "3497184c8ab1f9c350ac873b888e7367f2af91173f3405f4b87e3870a3568680"
    sha256 cellar: :any_skip_relocation, ventura:       "3497184c8ab1f9c350ac873b888e7367f2af91173f3405f4b87e3870a3568680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2157e843152c2bb08a3312488850e353746aaab1cb7fc9f6511014416f071f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72be486de5c7a50bc0bf325e671ee0e4e32d00fc2a2d045b8cfbf6033c68197c"
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
