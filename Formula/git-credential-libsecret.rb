class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.1.tar.xz"
  sha256 "e054a6e6c2b088bd1bff5f61ed9ba5aa91c9a3cd509539a4b41c5ddf02201f2f"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "99e10ad70f907d4f710721ba16c5d02a88887c50d056781ce337786437d2e084"
    sha256 cellar: :any,                 big_sur:       "c54fc5a1f4e8740a1414ed46f6bc6e5577e473625b280fffe516aca4b01bfac5"
    sha256 cellar: :any,                 catalina:      "9b02365e9e24df3d90d15d0b3b0ee548845b359151605a214bf53f842e48ef78"
    sha256 cellar: :any,                 mojave:        "c72707b7d79ef3ebb0a2e60bde9c01e70f54b820f2066d2dcafe7c65737eacde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5bda152d49e3450802c94d81f27d67dfbf0d436bff9c1309a36140f8ec986db"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

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
