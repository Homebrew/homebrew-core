class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.1.11.tar.gz"
  sha256 "e792d02c5613ef16cc6e988888a3379c9b4b931a8ed2e5d3f741a06c37a32f61"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "572b9b7662cfd297ef08dce64623f4a6f5d3255a94f766e79c1704671d8ad006"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "572b9b7662cfd297ef08dce64623f4a6f5d3255a94f766e79c1704671d8ad006"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "572b9b7662cfd297ef08dce64623f4a6f5d3255a94f766e79c1704671d8ad006"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e21077a5f046e8f37f93ee419aa108aecc1416da8eeac0acfb1679fd99fdb22"
    sha256 cellar: :any_skip_relocation, ventura:        "7e21077a5f046e8f37f93ee419aa108aecc1416da8eeac0acfb1679fd99fdb22"
    sha256 cellar: :any_skip_relocation, monterey:       "7e21077a5f046e8f37f93ee419aa108aecc1416da8eeac0acfb1679fd99fdb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "572b9b7662cfd297ef08dce64623f4a6f5d3255a94f766e79c1704671d8ad006"
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
