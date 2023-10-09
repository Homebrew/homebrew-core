class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.1.6.tar.gz"
  sha256 "4958df00f367ddc061fd78ae981e6e5d6daa3f58f148805328c1c3102e5d7120"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc36c22c814fb3aa0738a5ca832bde2f92d84026e65d3493a65a0c2706cbc2cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc36c22c814fb3aa0738a5ca832bde2f92d84026e65d3493a65a0c2706cbc2cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc36c22c814fb3aa0738a5ca832bde2f92d84026e65d3493a65a0c2706cbc2cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "618e37f2c0a065cdbdb07aa8c72ef42737cf1a9680d42f51c82cff6313fb755b"
    sha256 cellar: :any_skip_relocation, ventura:        "618e37f2c0a065cdbdb07aa8c72ef42737cf1a9680d42f51c82cff6313fb755b"
    sha256 cellar: :any_skip_relocation, monterey:       "618e37f2c0a065cdbdb07aa8c72ef42737cf1a9680d42f51c82cff6313fb755b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc36c22c814fb3aa0738a5ca832bde2f92d84026e65d3493a65a0c2706cbc2cd"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
