class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "50e805ff6043220efb0d23c128e47da8b82ca68f8c7d697e5b016613111a02c5"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a73362d1b3c0b39272aa0923ce08a0d336c12c187b349324d151ae5e0cd9731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a73362d1b3c0b39272aa0923ce08a0d336c12c187b349324d151ae5e0cd9731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a73362d1b3c0b39272aa0923ce08a0d336c12c187b349324d151ae5e0cd9731"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2ea76f11a81af5a16ff2ac91d39e71cc92ee1f7085ace443b9e6f246e02f6d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5528fe786e037c51defbe1e98434cfbd2e6ebd58f6a2dba25ec9f76e377a0bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9794fe91513d79aec4238d12190651a9e477f2ff542d4e8644e915bfb63a526"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
