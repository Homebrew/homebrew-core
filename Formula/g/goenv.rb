class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.7.tar.gz"
  sha256 "785500e22829498f1a4448e349a40a91e2db2bfba5784487b472233a86045328"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b463cb421e376973f326e285b6717a56e3b4413f1a640327f1fd02773e6e043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b463cb421e376973f326e285b6717a56e3b4413f1a640327f1fd02773e6e043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b463cb421e376973f326e285b6717a56e3b4413f1a640327f1fd02773e6e043"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea549db507cc22a42fcd231031a282579f37b3833a563fb7f7698f06e7e25de"
    sha256 cellar: :any_skip_relocation, ventura:       "dea549db507cc22a42fcd231031a282579f37b3833a563fb7f7698f06e7e25de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b463cb421e376973f326e285b6717a56e3b4413f1a640327f1fd02773e6e043"
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
