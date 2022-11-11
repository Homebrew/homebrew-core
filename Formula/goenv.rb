class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.3.tar.gz"
  sha256 "3abe015837742ded602d86625a8530698bb8910a66df3ed6a878d91fa608ed9c"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac224c5ffcb37322408a8943c0eee1a17ff846094c4234ca9f32af8a677700c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ac224c5ffcb37322408a8943c0eee1a17ff846094c4234ca9f32af8a677700c"
    sha256 cellar: :any_skip_relocation, monterey:       "9bd6025f8cfffe0501061544054631e415077abbfa6b59db87e82d44213a21cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bd6025f8cfffe0501061544054631e415077abbfa6b59db87e82d44213a21cc"
    sha256 cellar: :any_skip_relocation, catalina:       "9bd6025f8cfffe0501061544054631e415077abbfa6b59db87e82d44213a21cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ac224c5ffcb37322408a8943c0eee1a17ff846094c4234ca9f32af8a677700c"
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
