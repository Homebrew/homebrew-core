class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.7.tar.gz"
  sha256 "b2415dcd29e72ae42fbe8f0710c65c050faaa02b773ac68fd8393243aad5c409"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd261a0db092c6ea24bcf8c7cfd4a5337b75a7f5f9955b2df40478e491392c44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd261a0db092c6ea24bcf8c7cfd4a5337b75a7f5f9955b2df40478e491392c44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd261a0db092c6ea24bcf8c7cfd4a5337b75a7f5f9955b2df40478e491392c44"
    sha256 cellar: :any_skip_relocation, ventura:        "0018b938e4d2e88779d9538336880e802deb07255f8f202b59a7eccdec17433f"
    sha256 cellar: :any_skip_relocation, monterey:       "0018b938e4d2e88779d9538336880e802deb07255f8f202b59a7eccdec17433f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0018b938e4d2e88779d9538336880e802deb07255f8f202b59a7eccdec17433f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd261a0db092c6ea24bcf8c7cfd4a5337b75a7f5f9955b2df40478e491392c44"
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
