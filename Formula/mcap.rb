class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.12.tar.gz"
  sha256 "913d9feef3246495d6b81e7cf3abb48725f16a82b98b0e5a4d7bce5f8e8d6409"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b5f1e112d4b356a08ed183e064734b2c902d372c38a5e7b0940ca57a20c032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9b77b1dc1722574bc8f513edaee53ce1bd1de59fcd67164414990279ede1456"
    sha256 cellar: :any_skip_relocation, monterey:       "549e3734f0364460f0c135945c5b56b18cbeff962528abf3c5ccbbca9848cbac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d7b6de2e3696c134e036380de9fb5825528fe66915284bf8ed0b87a7126185"
    sha256 cellar: :any_skip_relocation, catalina:       "4d08598b813d99ee628aa73fb575a34f70923a5c4e7155f30e087ca8a3ee217b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ef5fe622d084d4d672f674ebbbccedbfb301c2af4860a04171eb7cb4145c17"
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
