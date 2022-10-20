class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/v2.3.0.tar.gz"
  sha256 "e1866471dd3fc5d52fd18af5df489a25dca1168bf2517db2ee8fb976eee1e78a"
  license "MIT"
  head "https://github.com/filhodanuvem/gitql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf057b9ba370bc1f4f5c7f2a28df41484304a9acd1578179c9bbe235b187218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c51c047a1b0a54fc0442b8116cab4ac4fe15e32a81e1eab298d7ae335350abf"
    sha256 cellar: :any_skip_relocation, monterey:       "c49e5de44b1ca2e817df8fec931424773605fca428a8552d72bf8f2e4201f738"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da2c5aeb11978212534942830e5dbf06df531e9c20ae13f046fb3c9a8cacee2"
    sha256 cellar: :any_skip_relocation, catalina:       "2a12d8521aa575a1d6026747e3ba1b8aa7887d2bbe260965fe0eea13ff97a5d6"
    sha256 cellar: :any_skip_relocation, mojave:         "a0762c0080eabc925f05e4a62de0fb9fc9cca8a9a948a9d4cb2d323ab1df8873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28081d93f6606dc4a39b1dfde118c3d21a909487b289538e86801de3febf1604"
  end

  depends_on "go" => :build

  # Support 1.18 by updating dependencies.
  # Remove with the next release.
  patch do
    url "https://github.com/filhodanuvem/gitql/commit/1bad3899592b0a8265e4a9c66e1c26e0bcbcd111.patch?full_index=1"
    sha256 "b002683a2eac09f7342869cbbcb94a971f51db03fc7895bf7fa5a8069b030378"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "A U Thor"
    system "git", "config", "user.email", "author@example.com"
    (testpath/"README").write "test"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match "Initial commit", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
