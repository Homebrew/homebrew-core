class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.50.1.tar.xz"
  sha256 "7e3e6c36decbd8f1eedd14d42db6674be03671c2204864befa2a41756c5c8fc4"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd059ab2604dc412c714403a60240215a5824433a17e6f085af27d432f7abe96"
    sha256 cellar: :any,                 arm64_sonoma:  "de7a29e8c60a06bd769f6dfb0b055e0bacd9fbd52cd5b0c4ad0466e1a3487355"
    sha256 cellar: :any,                 arm64_ventura: "a5ae4fdf0dc02e768b8c00dda85d0f579d81856a79976e3ff7008a0000fe3ad9"
    sha256 cellar: :any,                 sonoma:        "a2ae9c20bbb578fd568b3509a135316e3182a01a281a806c3377273f93c48756"
    sha256 cellar: :any,                 ventura:       "7a429d674cfd73255d4a1e7fba6efabcd0781ada2ca09ecf01f4601d7ee5fcf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85802c38c83b5b38d14d4ea0f3346a82607551a63bc174b1bfc0954c2183cacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04be398beb7f8e6ff022e648eb9697d481d51662591e6bb9071193f1cc973f0"
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
