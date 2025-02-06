class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.19.tar.gz"
  sha256 "ae443164836a3ded8dfd772b081c55864bbd31016d3dd8303fea5cf0fce8010c"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6219800cc21d70c329760bc029032547df374f8a588a427cffd379282ae60e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6219800cc21d70c329760bc029032547df374f8a588a427cffd379282ae60e15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6219800cc21d70c329760bc029032547df374f8a588a427cffd379282ae60e15"
    sha256 cellar: :any_skip_relocation, sonoma:        "87aea6c22a1c6fa21618f74d38e20a4b8d3f3ed66d6d4b591fee5a421effd445"
    sha256 cellar: :any_skip_relocation, ventura:       "87aea6c22a1c6fa21618f74d38e20a4b8d3f3ed66d6d4b591fee5a421effd445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6219800cc21d70c329760bc029032547df374f8a588a427cffd379282ae60e15"
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
