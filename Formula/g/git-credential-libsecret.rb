class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.47.0.tar.xz"
  sha256 "1ce114da88704271b43e027c51e04d9399f8c88e9ef7542dae7aebae7d87bc4e"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88e0d91301c837f8808d210b1f7431809e4bc8a5d53cb96ba69d9bbf759f46ba"
    sha256 cellar: :any,                 arm64_sonoma:  "2c80204926090116526405f930b1692ef9057c3cae310d5457e57bd13e692cbb"
    sha256 cellar: :any,                 arm64_ventura: "3edd3bb5089bde73907eab142668053348fa326a771422c1b59c4b711dcdffa0"
    sha256 cellar: :any,                 sonoma:        "228d185f8b3a6e020d48d5635d9c92afe61ef64391665f152fb9618f37238680"
    sha256 cellar: :any,                 ventura:       "c630c376327c88a1f2704f3236142be6bd09ba458c538a3c6b109d85e853838e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4242a9cda0a3878c3cd561f37d0d37f5d91724bb54a10aba21aa2844a3900309"
  end

  depends_on "pkg-config" => :build

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
