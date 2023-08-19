class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.41.0.tar.xz"
  sha256 "e748bafd424cfe80b212cbc6f1bbccc3a47d4862fb1eb7988877750478568040"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dffffba1123e1e29392f7302d40619eed1155b5dbb36c2ec40449cb30e7e7906"
    sha256 cellar: :any,                 arm64_monterey: "ec14f34e65a33fe638e53a474b9c3a1fd60c194fe3bedcddb14cda947f364fe3"
    sha256 cellar: :any,                 arm64_big_sur:  "6c688460f222326a4ee8f19bf866d981d41968d1bb7f683c5f0e4ff5b5f28b02"
    sha256 cellar: :any,                 ventura:        "ce3972dc8b65e410bf5e6c3ce1f80f0968c8f22e603c16a28d046e06ee2b8b78"
    sha256 cellar: :any,                 monterey:       "8b0175ad6b0b5705cd9ad4122be6e6283e2b90f3bd1ef10ca3be807683ee5e05"
    sha256 cellar: :any,                 big_sur:        "0977728e6e9f7c776cbb27638dc35c72fc647a4199f7c6dafca0083d6b6658c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98b5c8464eae0b0639002ed2135fb812dd05922e5719aa8a6eca300ce513a828"
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
