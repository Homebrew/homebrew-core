class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v2.0.1.tar.gz"
  sha256 "9e504b9d0aadac98247dcb6b499d6a5d761eb404c2ea74b1ee02784a1b4aef0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f920b4f77c931c3448e99c8523cd86ad019c3095dd6600fbed82668a7f2937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "931a9d4a96da5996d39e7c736d91c6dc7c4806408ea884a4eb185ad06e6b204e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1ab0bacb6245849a9fad96b84c58e4ac11198de12df26ccfb6cfeb372fcb9fb"
    sha256 cellar: :any_skip_relocation, ventura:        "6a67e581e921721f0cfabeb30dd6a2c90f0bf728e8b808848e721090d49a624a"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0b0ceabc024ac9411705c0213e18b1c3365b4dd12d397d60518404a877c723"
    sha256 cellar: :any_skip_relocation, big_sur:        "60b34121c7225227cd6dbf3f72ae732d642dd02531e526fa10c0027db536fbb2"
    sha256 cellar: :any_skip_relocation, catalina:       "eb8e60109ef370ae2e0eae6311a04b8e8a066dd16451d198583eab042c6572de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb81f183836be1dbf294eb484b487c292635e3f78803c326d984ae38fed3333d"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
