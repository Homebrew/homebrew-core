class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.37.tar.gz"
  sha256 "fbb2d8fa31f41b9e4c660c1cab7a62bdc4d52666079136904c49a929b05c5e51"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffc5b8de1d9aca5a793905bc6a6174f9ffdb8046c0f69f56da5b9081f42053cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc5b8de1d9aca5a793905bc6a6174f9ffdb8046c0f69f56da5b9081f42053cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc5b8de1d9aca5a793905bc6a6174f9ffdb8046c0f69f56da5b9081f42053cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f41066acb6769894b56bd658423e605c7369ef11261fa1f172ca47f7124835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffc5b8de1d9aca5a793905bc6a6174f9ffdb8046c0f69f56da5b9081f42053cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc5b8de1d9aca5a793905bc6a6174f9ffdb8046c0f69f56da5b9081f42053cb"
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
