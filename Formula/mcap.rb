class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.10.tar.gz"
  sha256 "767a9cc2ced1c479604156b7b67166c95d6a52c7c4f382e40e43689f9919a143"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5e2c2fb4f079bcde2ff7b0411034dd94993db2a45313797bc785d87b04497a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4575d12c6a040f36566d8a20903c119af26badb6d2ac3aa800f4d1b8787bb20f"
    sha256 cellar: :any_skip_relocation, monterey:       "ec707d080895a6dc9e98929b55a4bf2f7c6039156a76b3c4462e515059d6434b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b34d8c22a0c45f3641aa880e173a61841e1d03326cfb0176f863b76d143b3ed"
    sha256 cellar: :any_skip_relocation, catalina:       "62e92f70b8e8c6402a2de75e8c81f31a7be51ad1e9759f1f19a11d91b6eeb609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae5d8d8512badfb023e677d4b76135333f7d4263cb8075dd27d628638b89629"
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
