class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.1.7.tar.gz"
  sha256 "dca6dcb68f04092e890c1444f4954d64b278f1d77aaae9e73a64b2afaa96fe08"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c23c03e936a75048029f1185d289706bf837b5f2abe5f40c49cc5fd86727054"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c23c03e936a75048029f1185d289706bf837b5f2abe5f40c49cc5fd86727054"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c23c03e936a75048029f1185d289706bf837b5f2abe5f40c49cc5fd86727054"
    sha256 cellar: :any_skip_relocation, sonoma:         "96bf6e5d1a13759566c0ba4298c06f5a28dd802d7326ec35a25e03c1a56cbada"
    sha256 cellar: :any_skip_relocation, ventura:        "96bf6e5d1a13759566c0ba4298c06f5a28dd802d7326ec35a25e03c1a56cbada"
    sha256 cellar: :any_skip_relocation, monterey:       "96bf6e5d1a13759566c0ba4298c06f5a28dd802d7326ec35a25e03c1a56cbada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c23c03e936a75048029f1185d289706bf837b5f2abe5f40c49cc5fd86727054"
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
