class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.12.tar.gz"
  sha256 "913d9feef3246495d6b81e7cf3abb48725f16a82b98b0e5a4d7bce5f8e8d6409"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2307f2d48767b283b73af9365a3681231d982e349c2328919366c06b7c1acabd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef4f0f154f4fe2e4debb9b162778582197308efd25d1742698d07801ff46ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "507590a6203bf5e38fe1c6a31b5bea4b2e7e706d52d39f109618a9c1b14a68dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "22ae3a5bac7820d5305f0abc9829f40f813d22814a0cc6aa0e14b366bb188f67"
    sha256 cellar: :any_skip_relocation, catalina:       "45f78d9cfef3c05ef80fb1b9113f0208609eb2414e630c550e15e04cbd833840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b4040a34ef2ee8beec4a2135041d8ef0402e20dd4288dad99619123eecb200"
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
