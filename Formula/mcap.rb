class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.5.tar.gz"
  sha256 "165ab4d47ca893a92f87829a1bf8dc1aa877e44dba3139d09c8552e04855e464"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  depends_on "go" => :build

  resource "testdata" do
    url "https://media.githubusercontent.com/media/foxglove/mcap/releases/mcap-cli/v0.0.5/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
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

      assert_equal "2 example [Example] [1 2 3 0 0 0 102 111 111 3]...",
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
          	(1) example  1 msgs (+Inf Hz)   : Example [c]
        attachments: 0
      EOF
      assert_equal expected_info.lines.map(&:strip),
        shell_output("#{bin}/mcap info OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").lines.map(&:strip)
    end
  end
end
