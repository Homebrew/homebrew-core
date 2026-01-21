class PyenvCcache < Formula
  desc "Make Python build faster, using the leverage of `ccache`"
  homepage "https://github.com/pyenv/pyenv-ccache"
  url "https://github.com/pyenv/pyenv-ccache/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "ebfb8a5ed754df485b3f391078c5dc913f0587791a5e3815e61078f0db180b9e"
  license "MIT"
  head "https://github.com/pyenv/pyenv-ccache.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9e3904fdb63362c45c9e2ccd1421a83a444125518b176c5b86c8a547eebd2b56"
  end

  depends_on "ccache"
  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    output = shell_output("eval \"$(pyenv init -)\" && pyenv hooks install && ls")
    assert_match "ccache.bash", output
  end
end
