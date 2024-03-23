class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "f2176fa253588fe4b7118bf83f4316ae3ecb914ae1e99aad8c474e23cea49fb8"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa67afc9301e53f0d9c9cdea51f7961541b8a064348ae669ce9b78e26ac623ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1f2fa7ccf783321da492f96df275dc9e7794344b57eb331c964b3698c076bfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d10b3248296d6377edfe2be208c62a095bf26528054465c75b676b9450cf71"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c8a45629756b110a79694abd05541581da4fe5aea846ce2109f393555d36e16"
    sha256 cellar: :any_skip_relocation, ventura:        "992eb14986960531c0c315956eb311c6f5565a6d5c0bdb200d685ed6f5addb9e"
    sha256 cellar: :any_skip_relocation, monterey:       "2e790f701508550756d9ab0d64b99335470b2eee9e07e2df1f4e15ab70be34a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc82fe1c54fcabd0b4846149d37e442f54bde937a030c856848c594309f9a331"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' to do certain tasks
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "2" # cherry pick commit
    ENV["LAZYGIT_DAEMON_INSTRUCTION"] = "{\"Todo\":\"pick 401a0c3\"}"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "pick 401a0c3", (testpath/"git-rebase-todo").read
  end
end
