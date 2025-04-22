class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "164e1282ae1f2ea6a8af93c785d7bb214b09919ad8537b8fbab5b5bc8ee1a396"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  # Upstream may add/remove tags before releasing a version, so we check
  # GitHub releases instead of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8302833ac2fb9359a9219c8157f0f2b89cfc0a1c77878d333def7a43386aa33b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8302833ac2fb9359a9219c8157f0f2b89cfc0a1c77878d333def7a43386aa33b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8302833ac2fb9359a9219c8157f0f2b89cfc0a1c77878d333def7a43386aa33b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bd506a72e01572496aec534f019ba39752b8f8c9974cdae26c0aad3c2f9b247"
    sha256 cellar: :any_skip_relocation, ventura:       "8bd506a72e01572496aec534f019ba39752b8f8c9974cdae26c0aad3c2f9b247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b70125dde40f56f721d1f02904018d5ce9bfaf048a5c0cd4d22465a2a25851"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/f2"

    bash_completion.install "scripts/completions/f2.bash" => "f2"
    fish_completion.install "scripts/completions/f2.fish"
    zsh_completion.install "scripts/completions/f2.zsh" => "_f2"
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_path_exists testpath/"test1-foo.bar"
    assert_path_exists testpath/"test2-foo.bar"
    refute_path_exists testpath/"test1-foo.foo"
    refute_path_exists testpath/"test2-foo.foo"
  end
end
