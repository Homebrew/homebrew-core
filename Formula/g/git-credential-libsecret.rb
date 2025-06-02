class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.49.0.tar.xz"
  sha256 "618190cf590b7e9f6c11f91f23b1d267cd98c3ab33b850416d8758f8b5a85628"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e223f37a57a8e577b74f364695b2d0c9cd6f7525046cef4b2bc1a1e7fb85913"
    sha256 cellar: :any,                 arm64_sonoma:  "6fbfe94965969bfe72d9a628b66d48d4fd989c89776fae5937fa3e9413b82440"
    sha256 cellar: :any,                 arm64_ventura: "678e488118ce50b0508050942f62278db699df722623ac0e878fd2d04d52d6bb"
    sha256 cellar: :any,                 sonoma:        "0ea8d08fa5f2c6232f2e02e662103368212447c4c8f2befe3e4a93ec51aac83e"
    sha256 cellar: :any,                 ventura:       "b49735c2fbb0c3dfb5866560ca1045fdd914494d2f733432db0073450f3042f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473f1d57ba1b87591fe7432bef86eee8b0d59c81565ec26b87cc316b3767f9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0224bb1302993382a34c111dac7415d3a32940ba18ca02e8b2329eed1a9b292a"
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
