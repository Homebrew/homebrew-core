class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.34.tar.gz"
  sha256 "99f94ec500df813cd937665e21b0aab8c58809b944ee9f729b49cdaa3a400224"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2cfe84fc5951e9b01f6cf7c2b356302b756a27b61cb12acd35907183adfd23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2cfe84fc5951e9b01f6cf7c2b356302b756a27b61cb12acd35907183adfd23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2cfe84fc5951e9b01f6cf7c2b356302b756a27b61cb12acd35907183adfd23"
    sha256 cellar: :any_skip_relocation, sonoma:        "db47dffcbe1c3258d14a1a2ef9e99d7cc14fbf2a2c28b06764b4d8c6c45c47f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af2cfe84fc5951e9b01f6cf7c2b356302b756a27b61cb12acd35907183adfd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af2cfe84fc5951e9b01f6cf7c2b356302b756a27b61cb12acd35907183adfd23"
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
