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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49fc7c1bf7388aed0526070c65ad0117fba7c8b5e108c2dbb00b49910610783e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49fc7c1bf7388aed0526070c65ad0117fba7c8b5e108c2dbb00b49910610783e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49fc7c1bf7388aed0526070c65ad0117fba7c8b5e108c2dbb00b49910610783e"
    sha256 cellar: :any_skip_relocation, sonoma:        "053b2552837f44c9ddb789f1bc6c8ca59fbf8647eb37f1d81629f998059f66fb"
    sha256 cellar: :any_skip_relocation, ventura:       "053b2552837f44c9ddb789f1bc6c8ca59fbf8647eb37f1d81629f998059f66fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49fc7c1bf7388aed0526070c65ad0117fba7c8b5e108c2dbb00b49910610783e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49fc7c1bf7388aed0526070c65ad0117fba7c8b5e108c2dbb00b49910610783e"
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
