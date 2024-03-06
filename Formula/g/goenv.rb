class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.1.13.tar.gz"
  sha256 "1ec9fe547b996f0e191aa2a985eaca7565773d1b0c3e94152d3464c545048fc5"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b636dc18ee675c373e151edfb8d11a2e2eb0cb5276481018870a5c111c5792d"
    sha256 cellar: :any_skip_relocation, ventura:        "3b636dc18ee675c373e151edfb8d11a2e2eb0cb5276481018870a5c111c5792d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b636dc18ee675c373e151edfb8d11a2e2eb0cb5276481018870a5c111c5792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
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
