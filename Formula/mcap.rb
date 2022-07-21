class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.15.tar.gz"
  sha256 "b287c3999470caebcf8f97b15110d16fe9fcd8785536644a287e7435f99d883e"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238737945258ff59ce62ab1f8223bbaacdaa55999a9d576f11d282303a4addec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1d00e9dd20cfee5d40fd238fc51206ee3ec41d37fa54557c3606d0a7bd70a27"
    sha256 cellar: :any_skip_relocation, monterey:       "52ab1fe93efa19c62b56118bf76bd81f980fe2479c24ed82d407e3663901a7ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e3730f2bc29612a643044d406dd08667f8150523fffa5ca9cc6af3ec900820c"
    sha256 cellar: :any_skip_relocation, catalina:       "84491710ced5fa040c3eaf5d7c35958a770c09b7594a278ccdf2c94c7e764cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f1ad200c5413d248738da3570e36b1839a4065fbd2c468d0a9608650e67ca4"
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
