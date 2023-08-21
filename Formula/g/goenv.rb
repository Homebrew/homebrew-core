class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.1.4.tar.gz"
  sha256 "073d0149f8971c5af6bb98458cc1d85d5fcbf00b6080387e84093ad9e805e79e"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "182907fde11e7bd046752b8bd9a8dccfe662bdbdd515914d727f0da7f477c478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "182907fde11e7bd046752b8bd9a8dccfe662bdbdd515914d727f0da7f477c478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "182907fde11e7bd046752b8bd9a8dccfe662bdbdd515914d727f0da7f477c478"
    sha256 cellar: :any_skip_relocation, ventura:        "cbe0b2900942a72bdf1e138d56b2c4d76229a31fc6fa52f64a300f19abcb203b"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe0b2900942a72bdf1e138d56b2c4d76229a31fc6fa52f64a300f19abcb203b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbe0b2900942a72bdf1e138d56b2c4d76229a31fc6fa52f64a300f19abcb203b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182907fde11e7bd046752b8bd9a8dccfe662bdbdd515914d727f0da7f477c478"
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
