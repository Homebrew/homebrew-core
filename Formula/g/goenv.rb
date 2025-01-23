class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.18.tar.gz"
  sha256 "3739f7379798b3e2670ec09fd5f946b235dcec09ff6dd7c3141b2dc9bf211590"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7efb419c6ba94a70406f16e730d74cc6f07501782f6267db006529c3f75cb2b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7efb419c6ba94a70406f16e730d74cc6f07501782f6267db006529c3f75cb2b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7efb419c6ba94a70406f16e730d74cc6f07501782f6267db006529c3f75cb2b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "13555f13e14aff29f9f9d6b02ef5e830db9841a71272e718af2e9071ae6121ba"
    sha256 cellar: :any_skip_relocation, ventura:       "13555f13e14aff29f9f9d6b02ef5e830db9841a71272e718af2e9071ae6121ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7efb419c6ba94a70406f16e730d74cc6f07501782f6267db006529c3f75cb2b1"
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
