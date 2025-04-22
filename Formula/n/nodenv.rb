class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f11bd5acd3ff99c5a1b4df3f0cc6bca0814ec03df658ad90f53e5f2f173a25e8"
  license "MIT"
  head "https://github.com/nodenv/nodenv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cb8c3e5c3bec0417f019c7c50ed7151ff7f401ab52a3e6eabd63f7d67a523700"
    sha256 cellar: :any,                 arm64_sonoma:   "95484196709cd9fa76534d9baf11807a588699fef0e706723732fda6560e1f15"
    sha256 cellar: :any,                 arm64_ventura:  "ea7d85a9a683cfa60b81ff25dd6f5cf03147f7c1a96865356bfcc3240b5fa183"
    sha256 cellar: :any,                 arm64_monterey: "ca9de16f487e86fe442702a0a7e88b3abfd5020c355659fd8c052989397a22d4"
    sha256 cellar: :any,                 sonoma:         "0cd1dc555dc16d7120944a6e5998c037573d9aa2fed040d2d53eb9ccfb35f330"
    sha256 cellar: :any,                 ventura:        "7d77938b7d856eeca7535de6171805392a59338e3a22f31fcfa478ab37fcbc29"
    sha256 cellar: :any,                 monterey:       "2f344ef55716f73ee7ad9ebe9b6b09581010dea4955559eb1f7d5519c14a9c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "33a5bcabce0ae707a9b863ff16f16cab19c064fdfbe13d5f0a1af5c78a58f248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506fa918399e018d9492f86a2caa5bfe58ec4fe42561cfcd46c3a4c34e3bc81c"
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
