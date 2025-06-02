class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.23.tar.gz"
  sha256 "1377c6e75e48e92932f65f41f80dad59307eee2d1f644bdd42fc45453517ce21"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58437356ca3fdb08fb0102b6cd0baf241f6335217c785e0104d1422828938db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58437356ca3fdb08fb0102b6cd0baf241f6335217c785e0104d1422828938db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58437356ca3fdb08fb0102b6cd0baf241f6335217c785e0104d1422828938db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d91219e970a6157c8cdc5d25248548b9700de43dde859ec3d8630bafe920f5"
    sha256 cellar: :any_skip_relocation, ventura:       "f3d91219e970a6157c8cdc5d25248548b9700de43dde859ec3d8630bafe920f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58437356ca3fdb08fb0102b6cd0baf241f6335217c785e0104d1422828938db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58437356ca3fdb08fb0102b6cd0baf241f6335217c785e0104d1422828938db7"
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
