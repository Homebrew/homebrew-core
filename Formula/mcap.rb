class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.16.tar.gz"
  sha256 "289f6ab2f9b1efa655e8b3f6ed2baceb20ba4affd37194d20d4fb0bdd988c577"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c7661c4e5a43bd0677d38a48fb2b43cae76dfc8ebafe0b6f8796f94e7a6352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2f2809df9841faebd0a0a6b664a9e704691636c94012245fcbb0f0c89c1b59a"
    sha256 cellar: :any_skip_relocation, monterey:       "a68e7839c8bfe1070af41181c5b0edc3476eafb682547800840162f45715947d"
    sha256 cellar: :any_skip_relocation, big_sur:        "83ef6989f19ff2584940ce334698e08159c1feee03f5d1ea138d1092bb5b90ba"
    sha256 cellar: :any_skip_relocation, catalina:       "0d7467f257843bd43af55ce0c7a2f8b5fc44228368c2301ff7f4d5f4f7675ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c116841d3cfa3e4989cbbb3e5cd46e956b6a07bc6a2349e79442652671bafd5f"
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
