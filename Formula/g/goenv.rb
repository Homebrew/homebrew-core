class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.1.14.tar.gz"
  sha256 "4a4ac864bfd8e62f1353910ccd612cb8c28c55bb18d420b314367670804b32f7"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1967c51cb098f2d57c6efdcc696867ca171cae45a163cfd68e766d1fd056a581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1967c51cb098f2d57c6efdcc696867ca171cae45a163cfd68e766d1fd056a581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1967c51cb098f2d57c6efdcc696867ca171cae45a163cfd68e766d1fd056a581"
    sha256 cellar: :any_skip_relocation, sonoma:         "a12478133c5887808a3adf22d569cda3c8994fe90de7b8af3eca1cb7f23dfa02"
    sha256 cellar: :any_skip_relocation, ventura:        "a12478133c5887808a3adf22d569cda3c8994fe90de7b8af3eca1cb7f23dfa02"
    sha256 cellar: :any_skip_relocation, monterey:       "a12478133c5887808a3adf22d569cda3c8994fe90de7b8af3eca1cb7f23dfa02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1967c51cb098f2d57c6efdcc696867ca171cae45a163cfd68e766d1fd056a581"
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
