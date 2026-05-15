class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "4c0afa6edec859335ff01eed42e9ec0d763a5ee4dd3d22c862575c823472a1a9"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9956bc790bbee8a9fa74baff7593c91738508c0e315f3002fc79c16b4c5c9781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9956bc790bbee8a9fa74baff7593c91738508c0e315f3002fc79c16b4c5c9781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9956bc790bbee8a9fa74baff7593c91738508c0e315f3002fc79c16b4c5c9781"
    sha256 cellar: :any_skip_relocation, sonoma:        "d70ec0f635232656a5328e6002eb26a7d09fc4a96d4dc38b291dc890e0d92b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0f46a4f154463af48db0ddc280ed2b3a25a33eda9ad207bfbded4c2d220c96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04187d0af9e083a543cdedfb7fc707275db6681c51e141ff87ce2fc71ff68edc"
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
