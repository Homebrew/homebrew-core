class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/1.23.3.tar.gz"
  sha256 "1559f2907ee0339328466fe93f3c9637b7674917db81754412c7f842749e3201"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10f497d42374919dd532af5c7af60a1c25029720d3f807e00e5315ade65999c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "05ca9b052b0ff4a3de3acb1d3b7c767ca60bf80cd756c8ecaea51f7f97734fed"
    sha256 cellar: :any_skip_relocation, catalina:      "05ca9b052b0ff4a3de3acb1d3b7c767ca60bf80cd756c8ecaea51f7f97734fed"
    sha256 cellar: :any_skip_relocation, mojave:        "05ca9b052b0ff4a3de3acb1d3b7c767ca60bf80cd756c8ecaea51f7f97734fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "979222eb942ecefdcb16a2f009e3a78ea58a3197f6c12b4c4c2555dafcc4f41c"
  end

  def install
    inreplace "libexec/goenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
