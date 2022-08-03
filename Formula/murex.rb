class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.10.2400.tar.gz"
  sha256 "4503e20d144cdadf60e01b97d420bc3ab7d35b3c079712fd3e37477bdeac67b3"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e137ebddffbdf8023398c5f1c22ee3ad94ad6f2e1f61d00d7093ca49be15e7f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61bc6b591509dcb044cbeb20cb0e5c65358e831221b1de0791f9d8d7a8590b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "66e88d0a42691eb4039567d03f02e462a2c3bf32336ee79575ff05a38ec7f45b"
    sha256 cellar: :any_skip_relocation, big_sur:        "25bfa3ea3b2de0c2f9414e10df274822e535eb5b2211e0cda9b80e7276f47bdb"
    sha256 cellar: :any_skip_relocation, catalina:       "7e14d7b0e2137ef4240f7096293a8fcf11a6fc22ec2c0e86cbd5aa58180ae3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "996ae9f11e7b20df55561ddc701c85148a638bb532bce9249552e0129e03d2a4"
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
