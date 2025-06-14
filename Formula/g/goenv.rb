class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.25.tar.gz"
  sha256 "c2c49ee706629f0dcc85ded7290f65536325364bf47b606ec76255ddbb3132a5"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d9d051ae421da92d16d267d6490059f0c1a34bac0269fdaadf495fcdbd5a17c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d9d051ae421da92d16d267d6490059f0c1a34bac0269fdaadf495fcdbd5a17c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d9d051ae421da92d16d267d6490059f0c1a34bac0269fdaadf495fcdbd5a17c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d2ee73c6bd310c8c5e2f0cdb1b85d9faaa23c0d5f113e3aa83a486af3bcf370"
    sha256 cellar: :any_skip_relocation, ventura:       "2d2ee73c6bd310c8c5e2f0cdb1b85d9faaa23c0d5f113e3aa83a486af3bcf370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d9d051ae421da92d16d267d6490059f0c1a34bac0269fdaadf495fcdbd5a17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9d051ae421da92d16d267d6490059f0c1a34bac0269fdaadf495fcdbd5a17c"
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
