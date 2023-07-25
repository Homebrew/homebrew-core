class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.0.8.tar.gz"
  sha256 "026ebcecdd6dc97f1d2127ce3baf918f4ff18bc09e099a3a98b19169b7c8bb33"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5358f182a9b632ddbfce3c50b15c842339c3461e4bea51115ddcda2a6309a6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5358f182a9b632ddbfce3c50b15c842339c3461e4bea51115ddcda2a6309a6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5358f182a9b632ddbfce3c50b15c842339c3461e4bea51115ddcda2a6309a6a"
    sha256 cellar: :any_skip_relocation, ventura:        "31756155c537d9164235172010b3a2aa0a41531ad9ffd258c9c81e9ef10871d9"
    sha256 cellar: :any_skip_relocation, monterey:       "31756155c537d9164235172010b3a2aa0a41531ad9ffd258c9c81e9ef10871d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "31756155c537d9164235172010b3a2aa0a41531ad9ffd258c9c81e9ef10871d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a632433aee67e4d7617db38ec3b44cc8f6a3d7f9d8ab451615b7f723d4f932"
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
