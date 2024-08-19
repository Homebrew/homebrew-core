class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.4.tar.gz"
  sha256 "fd11151546235a2abd3bde542a1e148654b7a3c6f75f45bf8e599cc91cf01527"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6166d43c934a147ee9f61582d2dfc5a621a49ab4fab5ef1f74fc310467ce1983"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6166d43c934a147ee9f61582d2dfc5a621a49ab4fab5ef1f74fc310467ce1983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6166d43c934a147ee9f61582d2dfc5a621a49ab4fab5ef1f74fc310467ce1983"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d969e29b156d0224cb1c841c2e3020ccf3142213d1c2ae51f2f00d59e2bff57"
    sha256 cellar: :any_skip_relocation, ventura:        "0d969e29b156d0224cb1c841c2e3020ccf3142213d1c2ae51f2f00d59e2bff57"
    sha256 cellar: :any_skip_relocation, monterey:       "0d969e29b156d0224cb1c841c2e3020ccf3142213d1c2ae51f2f00d59e2bff57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6166d43c934a147ee9f61582d2dfc5a621a49ab4fab5ef1f74fc310467ce1983"
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
