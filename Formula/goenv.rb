class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.2.tar.gz"
  sha256 "478c9dd238a589c07e205dbbea596bbfa0719ee9978d1fbc13f63050b7c2e789"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9f5c36fe507bcd9486d4166b27bddd6281a8f6556b5ec63dd2d7b714f7e2e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e9f5c36fe507bcd9486d4166b27bddd6281a8f6556b5ec63dd2d7b714f7e2e7"
    sha256 cellar: :any_skip_relocation, monterey:       "2a2c66189b844610a38abafd26f0d70d92a905cc4d793148539a192b7bae319b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a2c66189b844610a38abafd26f0d70d92a905cc4d793148539a192b7bae319b"
    sha256 cellar: :any_skip_relocation, catalina:       "2a2c66189b844610a38abafd26f0d70d92a905cc4d793148539a192b7bae319b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e9f5c36fe507bcd9486d4166b27bddd6281a8f6556b5ec63dd2d7b714f7e2e7"
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
