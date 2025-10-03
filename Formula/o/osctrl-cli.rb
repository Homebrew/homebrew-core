class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "bcd8637d5000e16f22ba97698ae50862dd7ed3358a51f85ad54fdbd69651037c"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3cdc75e7688705575e368f106bd506f8fc53b515ca959c417336731ceba8b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cb7988e7c77908ed7d655b9b34972706ee0b580ab74bf6001215da0cb2204a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f6820ef33aa8380f4bfe50d719f2f924bc5f1025ea9ee047b4c1c75710c012"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef27466a962721e0d89568cafbbe3a50695a08a74dfff3da4df2b3089bd8dcbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a12af433dfa24002d2e0ca74e8db6d8b6663846e22c78c090379c3ee3114704"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
