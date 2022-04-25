class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.6.tar.gz"
  sha256 "f2adc1a2c1f81d4c5f5b684829013dcdf28f24f15ce34e4a72139ee01355d93a"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  depends_on "go" => :build

  resource "testdata" do
    url "https://media.githubusercontent.com/media/foxglove/mcap/releases/mcap-cli/v0.0.6/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "9db644f7fad2a256b891946a011fb23127b95d67dc03551b78224aa6cad8c5db"
  end

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
  end

  test do
    resource("testdata").stage do
      assert_equal "v#{version}", pipe_output("#{bin}/mcap version").strip

      assert_equal "2 example [Example] [1 2 3]",
        shell_output("cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap | #{bin}/mcap cat").strip

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
          	(1) example  1 msgs (0.00 Hz)   : Example [c]
        attachments: 0
      EOF
      assert_equal expected_info.lines.map(&:strip),
        shell_output("#{bin}/mcap info OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").lines.map(&:strip)
    end
  end
end
