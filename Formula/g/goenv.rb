class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.8.tar.gz"
  sha256 "61cb8e4db4196cb0b11afba1169c3b2bd904023716b6377039efdd52e787a8be"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e7d2b0c81ebe284d7a930bcc30545362dca29826cd0174afbc9c657f0a8bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e7d2b0c81ebe284d7a930bcc30545362dca29826cd0174afbc9c657f0a8bd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4e7d2b0c81ebe284d7a930bcc30545362dca29826cd0174afbc9c657f0a8bd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3fb8093f81c40839a24d1570ad63e6bf29a74cc3a12c39e6f64d869d15b0de"
    sha256 cellar: :any_skip_relocation, ventura:       "ed3fb8093f81c40839a24d1570ad63e6bf29a74cc3a12c39e6f64d869d15b0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e7d2b0c81ebe284d7a930bcc30545362dca29826cd0174afbc9c657f0a8bd3"
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
