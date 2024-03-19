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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88d78be25d78f8efbdd1d79b013b908f1e5960627560afa3611ba32c4ac62d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d78be25d78f8efbdd1d79b013b908f1e5960627560afa3611ba32c4ac62d42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d78be25d78f8efbdd1d79b013b908f1e5960627560afa3611ba32c4ac62d42"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e6bf62cae9617f99b5a3433d98bf45004114d2935bb3731bffeb558b2f30fed"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6bf62cae9617f99b5a3433d98bf45004114d2935bb3731bffeb558b2f30fed"
    sha256 cellar: :any_skip_relocation, monterey:       "6e6bf62cae9617f99b5a3433d98bf45004114d2935bb3731bffeb558b2f30fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d78be25d78f8efbdd1d79b013b908f1e5960627560afa3611ba32c4ac62d42"
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
