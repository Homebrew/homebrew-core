class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.4.0.tar.gz"
  sha256 "33e2f3e467219695ba114f75a7c769f3ee4e29b29c1c97a852aa001327ca9713"
  license "MIT"
  head "https://github.com/nodenv/nodenv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fece520035f8c55b65005231b038d9748f8bd13dc97a37fa4712a42d00ea6221"
    sha256 cellar: :any,                 arm64_big_sur:  "c86512e5a1505eb10c79a4aeb618db66cc08a48ac855e9c0f9fb9fba7868d5e7"
    sha256 cellar: :any,                 monterey:       "a20f7a9c8cee71ba311283d2f518f1f3f52a94d6757a5775021d9eda66a3cb98"
    sha256 cellar: :any,                 big_sur:        "b6cce4dccc468b49f71f989a3f6f0d505f198e2fa4604a0cd8a24f969901a6d6"
    sha256 cellar: :any,                 catalina:       "b5af0ac98407b7d246a41154c4ca9db9cad273b5fa65a487fcb080f3d15704f6"
    sha256 cellar: :any,                 mojave:         "69231fd7b4e38aee64caecb7582969f0abcbeacaaf4ebce6de700b2e20848e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891254a446324d72656e8e5b041ef5016525fad7afb91aa92a3c5447f3af04aa"
  end

  depends_on "node-build"

  def install
    inreplace "libexec/nodenv" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
    end

    %w[--version hooks versions].each do |cmd|
      inreplace "libexec/nodenv-#{cmd}", "${BASH_SOURCE%/*}", libexec
    end

    # Compile bash extension
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `nodenv --version` output
      inreplace "libexec/nodenv---version", /^(version=.+)/,
                                           "\\1--g#{Utils.git_short_head}"
    end

    prefix.install "bin", "completions", "libexec"
  end

  test do
    shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv --version")
  end
end
