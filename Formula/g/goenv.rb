class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.13.tar.gz"
  sha256 "056039036937d017bcefa7e4ff11dc032964bfd818e468247259d6a4d8ddb527"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
    sha256 cellar: :any_skip_relocation, sonoma:        "62cf6a53c1d573674d2a8fb356d13c3cb19606a94c63aad3452991f1b7058587"
    sha256 cellar: :any_skip_relocation, ventura:       "62cf6a53c1d573674d2a8fb356d13c3cb19606a94c63aad3452991f1b7058587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
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
