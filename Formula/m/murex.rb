class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v6.3.4225.tar.gz"
  sha256 "2b727bd89c63a50531294d06e1c59e5b120b312bd1877b8803083e301ac8980f"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c4ef7ed09b6c0efb8d14fec040dfcc7359af32ff5939ee1baefd64f297d74e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c4ef7ed09b6c0efb8d14fec040dfcc7359af32ff5939ee1baefd64f297d74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c4ef7ed09b6c0efb8d14fec040dfcc7359af32ff5939ee1baefd64f297d74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b4099bee3d31f8a05f43cf232e12db66248203f428da46cd152ec0928e89df"
    sha256 cellar: :any_skip_relocation, ventura:       "23b4099bee3d31f8a05f43cf232e12db66248203f428da46cd152ec0928e89df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae9bcc3d28134407e5f9d51ac0677f7b78e496d08efb8facf1fd741feffab2f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
