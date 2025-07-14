class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.26.tar.gz"
  sha256 "bbc27e677f25eeab97e74b43b2249d7a1894b0a5a6ae5d06068b277774762d0c"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e203356147b89483253e852807368c14710b1c050b8c47449f5466287cffd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e203356147b89483253e852807368c14710b1c050b8c47449f5466287cffd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02e203356147b89483253e852807368c14710b1c050b8c47449f5466287cffd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3187e62b42a848683f5a97555c713ba6cac18216d6001cb613dcdc7f3884c7fb"
    sha256 cellar: :any_skip_relocation, ventura:       "3187e62b42a848683f5a97555c713ba6cac18216d6001cb613dcdc7f3884c7fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e203356147b89483253e852807368c14710b1c050b8c47449f5466287cffd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e203356147b89483253e852807368c14710b1c050b8c47449f5466287cffd8"
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
