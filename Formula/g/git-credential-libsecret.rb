class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.56.1.tar.xz"
  sha256 "f0b0bf89264b9bd2e1c640363e7529643989da76281600473c50745cd34a607f"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f555c025e7b27a739243bea4a9c09b0a962616d7b31d69419931877dce487c6"
    sha256 cellar: :any, arm64_tahoe:       "28e1f4c84da1da03578c504f6dd6256e039b61d4bfbb8dcda66fa7765c5cbb89"
    sha256 cellar: :any, arm64_sequoia:     "5f81cf8e5cc6a968fcc20bb6c3ea94268329665d7df29a60808830a05bb39119"
    sha256 cellar: :any, arm64_linux:       "9816e69e5bcddf600ded0d214b59063a7fba510b6de9f1c39e6fd9de47a81714"
    sha256 cellar: :any, x86_64_linux:      "5d7746f83b3560ee7b4c8ce5e48e522856a0004b70502c9545b3f56021fe11cb"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libsecret"

  on_macos do
    depends_on "gettext"
  end

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS

    output = <<~EOS
      username=Homebrew
      password=123
    EOS

    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
