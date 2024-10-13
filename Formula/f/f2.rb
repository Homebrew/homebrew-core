class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "fbeb4540c4afe4aa25565685ee7ef7498449da7fc5f5b70a0e303b15c6e35f71"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b7ac240c241125e6a836e6e226da5e970d49317aee274a340b73d3aabe935d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "880773abf1e0dad9df8028ad85e46ed692da2a2df022aadb9dce65831afe5ccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05a3ff917d9aaab41874915d0270151d14b03d2b45b30346338ba0bc6bbe7aa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a3ff917d9aaab41874915d0270151d14b03d2b45b30346338ba0bc6bbe7aa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05a3ff917d9aaab41874915d0270151d14b03d2b45b30346338ba0bc6bbe7aa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3cff57e22dcad2cf8dce94843c59d4a23fd505afe60e3587fc49ffb1540e71e"
    sha256 cellar: :any_skip_relocation, ventura:        "640ad76f6012ed3c7d4dcc4f054e6edfa44621f3594303d32c3cd3c8763351ed"
    sha256 cellar: :any_skip_relocation, monterey:       "640ad76f6012ed3c7d4dcc4f054e6edfa44621f3594303d32c3cd3c8763351ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "640ad76f6012ed3c7d4dcc4f054e6edfa44621f3594303d32c3cd3c8763351ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ebec8aaa2a5d08b8516bc009e658923f3a55eb9df0d92ee8effd98207fabed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath/"test1-foo.bar", :exist?
    assert_predicate testpath/"test2-foo.bar", :exist?
    refute_predicate testpath/"test1-foo.foo", :exist?
    refute_predicate testpath/"test2-foo.foo", :exist?
  end
end
