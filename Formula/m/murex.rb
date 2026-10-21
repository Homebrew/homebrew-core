class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.3.1232.tar.gz"
  sha256 "a907bea8e343c3c3627fe4934233f352de2cc0f87d53230745534bd8f0037de4"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebec12002794e223cdc399161696710369675709e159db1c06364edd0f4e87d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebec12002794e223cdc399161696710369675709e159db1c06364edd0f4e87d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebec12002794e223cdc399161696710369675709e159db1c06364edd0f4e87d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "731cdbaa96d155b1519715178c14f372803448817e8deaa255a7ffc67dad09c8"
    sha256 cellar: :any,                 x86_64_linux:      "525c0d71c611fb36e689d81dfcf4b26dc21bb1ce0954e66343a91af3315250c5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
