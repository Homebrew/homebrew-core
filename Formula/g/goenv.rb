class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.1.15.tar.gz"
  sha256 "b5bdc7ea62e1ad81a7f125fd2a68d295d07b1d8aa8645fff9a57a9b015d4f4e9"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "873acbae176ab9d412ec1f84fdf4741426b73ba3289e86b73f5fd871ed48925d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "668fac23372cf1abf3014648119e6660f031a5f1f595527c38f18687bf2c9d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe56cf2d62157870a43a33e7a6aa5b1e230763d61b76fd308cb658caee80361a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3997fe0188c567edf528b1f0f48f9b7074b648f280874df6bbe4a922116106a9"
    sha256 cellar: :any_skip_relocation, ventura:        "24abca176c30d2a1a00e23f41b10ac24b0063f0e0463ed3dcf32a7b68a21c33f"
    sha256 cellar: :any_skip_relocation, monterey:       "7771d5822274959982e57426cfef822e23d068ef00df845e6c19669a557e6ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f3a3836bb7908eb8f65b4220ef0bd439c1c00d8f9029e63da890fea14e4cc6"
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
