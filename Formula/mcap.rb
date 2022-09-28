class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.20.tar.gz"
  sha256 "82066fd241eeb034b108213ebe540064fdb2b493e07afc86e24f244006a95acc"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a2a913a2210a98c2612853d819c9067f31aae16e47376913643d3960129f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ccdac52d70736a41af955d39841c44a40b23178d6f4b165c9901c9dd3d089f5"
    sha256 cellar: :any_skip_relocation, monterey:       "ebac07b54f4ce2c59dab68c124d06a462007d12c342e287a4dfc896f864e666a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a07cd2da0f621eb24d16d164e37f59a9fdc5a0a206040d500b79a5f7ac5c738"
    sha256 cellar: :any_skip_relocation, catalina:       "7198194bfad45958dcac035fcb4bd2ca362abd366c49e9fe8a1b46509fac282b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd2eb2ae940fffeb67605ba6f3b34e07e7a3d6c5d167ac977a3dfa2aeb959f1"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://media.githubusercontent.com/media/foxglove/mcap/releases/mcap-cli/v0.0.10/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "9db644f7fad2a256b891946a011fb23127b95d67dc03551b78224aa6cad8c5db"
  end

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
  end

  test do
    assert_equal "v#{version}", pipe_output("#{bin}/mcap version").strip

    resource("homebrew-testdata").stage do
      assert_equal "2 example [Example] [1 2 3]",
      pipe_output("#{bin}/mcap cat", File.read("OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap")).strip

      expected_info = <<~EOF
        library:
        profile:
        messages: 1
        duration: 0s
        start: 0.000
        end: 0.000
        compression:
        	: [1/1 chunks] (0.00%)
        channels:
          	(1) example  1 msgs (+Inf Hz)   : Example [c]
        attachments: 0
      EOF
      assert_equal expected_info.lines.map(&:strip),
        shell_output("#{bin}/mcap info OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").lines.map(&:strip)
    end
  end
end
