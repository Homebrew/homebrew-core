class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.29.tar.gz"
  sha256 "1a702dd8f5ce20ffcb9c96fc13c44ecc16a188992ae4d277ab13e36382465808"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aba102468a1f9e110207ce50fa02e196ecceaae5f938e1faa23b07f761395e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aba102468a1f9e110207ce50fa02e196ecceaae5f938e1faa23b07f761395e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aba102468a1f9e110207ce50fa02e196ecceaae5f938e1faa23b07f761395e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1aba102468a1f9e110207ce50fa02e196ecceaae5f938e1faa23b07f761395e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "82645b3f461a65c8812ddfe00ab415ba85b1afe6613b1edd35b4cb03d4510543"
    sha256 cellar: :any_skip_relocation, ventura:       "82645b3f461a65c8812ddfe00ab415ba85b1afe6613b1edd35b4cb03d4510543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aba102468a1f9e110207ce50fa02e196ecceaae5f938e1faa23b07f761395e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aba102468a1f9e110207ce50fa02e196ecceaae5f938e1faa23b07f761395e3"
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
