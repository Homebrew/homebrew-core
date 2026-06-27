class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://pvetui.org"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "70b0b5a706258772e93ded6997687f3360b7f7ff072bbcd1c6a00323a292aaac"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25cf3a29f81411b607e2f777fc90e7534dd3a6db6b08a59c00d4554fd119e88d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25cf3a29f81411b607e2f777fc90e7534dd3a6db6b08a59c00d4554fd119e88d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25cf3a29f81411b607e2f777fc90e7534dd3a6db6b08a59c00d4554fd119e88d"
    sha256 cellar: :any_skip_relocation, sonoma:        "75ce8b7b77a7a8441eb8859d0ce6c6fe235d75555ad255e6153d97102c855345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6f94518106c939db7fa86b77feb9e098fae9fc685f4cb3ca16b2c0c56198cc8"
    sha256 cellar: :any,                 x86_64_linux:  "c83d9002aff458d711cbd8529f0829a2d91b52848d1a3551c78ebbd2cb7ca0b3"
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
