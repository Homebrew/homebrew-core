class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.13.tar.gz"
  sha256 "e2d0986be7fe4715c1893c2ece73f858eb4f8ef01323437207c1494f2bb8771e"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61f55fc04c6095c5c1f053c7545623047ae62a0116157860e2f1970f76465e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dfd7ace4c4523f70cca08dd0aa62c5451d58d58c6280bf424e6c6de6538598f"
    sha256 cellar: :any_skip_relocation, monterey:       "16ec31fedf5295631683e27d2ef4ed4c7842333d9b44a1517b150e8435ca8c6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3746379b22707ec52c5c487ffd9a684212ea9748e205fb67fdd72d8e65be0dc2"
    sha256 cellar: :any_skip_relocation, catalina:       "ba801fd1314542f67f7171a2b44fee8c3daf6070cfd67c2ae8018b8f21392d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9bc4cc4ecf5a4fd605587f36a374c2bb1be48a1257be5715a19eee36391670"
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
