class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.0.tar.gz"
  sha256 "f0e0ff435da80b8011fb492ffb0e874a45a50f039ad5a1d50551ce5318cb01a9"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29420a0c5b0bc5bb8235dd8dfd5d06cb3d31b714c7d74d0b0fa47ec336616a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29420a0c5b0bc5bb8235dd8dfd5d06cb3d31b714c7d74d0b0fa47ec336616a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29420a0c5b0bc5bb8235dd8dfd5d06cb3d31b714c7d74d0b0fa47ec336616a94"
    sha256 cellar: :any_skip_relocation, sonoma:         "17d2dab7d54e73b57e176fc4e9efdad436a67177d7ba35b96990ab92d695e59d"
    sha256 cellar: :any_skip_relocation, ventura:        "17d2dab7d54e73b57e176fc4e9efdad436a67177d7ba35b96990ab92d695e59d"
    sha256 cellar: :any_skip_relocation, monterey:       "17d2dab7d54e73b57e176fc4e9efdad436a67177d7ba35b96990ab92d695e59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29420a0c5b0bc5bb8235dd8dfd5d06cb3d31b714c7d74d0b0fa47ec336616a94"
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
