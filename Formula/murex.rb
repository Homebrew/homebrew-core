class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.11.2000.tar.gz"
  sha256 "b8037307ee8da27ea218a8670d583fb392ca54f320d7cc7251e7a881a36b692a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "606b27e31018c88e2d2b05c0ef965659b1ef822fa9b6cc5662497410c6891b03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e791103ce8e98dabf8bbac76e575aeffd5f14575043d56fa046b136b2b34f70"
    sha256 cellar: :any_skip_relocation, monterey:       "5b330498fa90ae47b030a3d72d7f3a05b7df1e69bf960ca7f9a253cbb55d6729"
    sha256 cellar: :any_skip_relocation, big_sur:        "14468806cfb389d7b03923d5a867839f26f2098d3066a80ef52a49854d4c2190"
    sha256 cellar: :any_skip_relocation, catalina:       "5136b8a85748b4d2f76b26249a298dc9d2c24a771b802c4b84cc0221291d2dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bac520f0dedc1247c9f34ee30dea5f54581c67f4ad9a1bd37abab14fde32f2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
