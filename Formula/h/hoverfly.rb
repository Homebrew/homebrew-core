class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "6a645c0ff1eb01111d1256b72e153cc73be98f7d05de035d35c3b162407ba611"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f63507691497243fe99839780a3d39a2692d8ff3ac760e73832ec3aebddfcb9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f63507691497243fe99839780a3d39a2692d8ff3ac760e73832ec3aebddfcb9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f63507691497243fe99839780a3d39a2692d8ff3ac760e73832ec3aebddfcb9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "748f5d6d1b3237bd49a9fcc8d25a4f28acccb140ab5b27b290c92caba9dd3d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eabd7b1a4ae286c0adb063207543db654abb43424004bd5383181d85e8cb8675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57286b3a496cc57ae5a89b7bbd0787ad7f8e675a3b2fb18b47cdce6dc695a3a2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
