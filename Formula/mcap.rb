class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.19.tar.gz"
  sha256 "ce0aa5febb036db24f5cab5f4cf7daf3ddba77bce8f7b4a3afcd646ed154c608"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46dbe0ad39dd2af0930e69ca6f331761f11eee63ab0f7a615853003fdd94768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc2ed52527e9af357f0cc84901eecc9edd12dcdf84253b3510fc7a681ef72a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b9890b0916ad28ce16ee2bffbed8e85767d530b243770d0a495cb58152857091"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7528cc93a7573e69764750ec030208f8ae62d657873b4f8f1477fc7f7c5546b"
    sha256 cellar: :any_skip_relocation, catalina:       "b909758733893baa4e284860e210d4a636e7a9f9ea59056b35351c6ef8154f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db5626ed91590769ade1f9cc9811d3889b9ee6277f3a81c3f04b301440e5ac2"
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
