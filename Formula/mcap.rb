class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.17.tar.gz"
  sha256 "03495ce5af9950ac724f63107da7411b94be18d53dd3f439e4cca5a8d1593648"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d902cd4e31a1061ad5d919da48dcddeb8121148b677a8cd507c5ae07fa9607a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ea04ac4fdb0e31f07f045720515cb983972fecc5d4e92f53f9ff5bbf26bf8f"
    sha256 cellar: :any_skip_relocation, monterey:       "696580ac6df20fc02b7e3875660d296dec1d4cbe3427836748dfdd4499b05127"
    sha256 cellar: :any_skip_relocation, big_sur:        "edf113d3f0e4481ed40ec87fa5cbd5cbf0df6a43202d1fd2ade55670fdb1cca9"
    sha256 cellar: :any_skip_relocation, catalina:       "0181627fc8a5d9ba679e27e5ae67c452695632e500790ef230273877e49eab64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86eff6b58fd15a08b0f017d244e86701f05febab6688796cbb92b10354066683"
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
