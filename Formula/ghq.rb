class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.3.0",
      revision: "ccbbc18efc1802a5f9bf50d9fbb6b8b020c3f8f7"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a31421cb53f1e02c89ea90bad57294641a791b7443477f4e3bc7ac6cc1e5c0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c3c4b22cb50e06c75b1a268a9e5c83560277595e32aa706c67e9b5d21400b60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daf8e475bcb2917e46f6988e3656e0f700b5501fbaa60d5a793d1a2875f9144f"
    sha256 cellar: :any_skip_relocation, ventura:        "5ffa314454fcd18f6ff60fca94d86caa202fbd12ba0ceb5f4c7b00ef7271463e"
    sha256 cellar: :any_skip_relocation, monterey:       "38d099e4a5a7e67edd8e4a3be8f4f44e6eff4d157d9f00595298c80e48c6b593"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c141aa554879fbe830f03cda0e833e4f3a4c0f77864938168594c6aa7b6515a"
    sha256 cellar: :any_skip_relocation, catalina:       "d7c8f6c1b6d5d65f4547e91054f5c3d15a96e25487e34d62cb26dfcf80388424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c795523276c88efd6b43e2946d6f2c25339f341b58eda93c63596ac31977f8"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
