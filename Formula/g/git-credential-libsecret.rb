class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.48.1.tar.xz"
  sha256 "1c5d545f5dc1eb51e95d2c50d98fdf88b1a36ba1fa30e9ae5d5385c6024f82ad"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7c1b13de8b0338a523e748559f73d45512a9d08055dbbdb980c5a8c5dfca09a"
    sha256 cellar: :any,                 arm64_sonoma:  "844b82d9dc18941b7f2a572fdeff8e2f0593d366342b0134dadfb0df37bb6bef"
    sha256 cellar: :any,                 arm64_ventura: "444d4e43204c2946294ba59e96da8823707739757213fed36c725783adc7d458"
    sha256 cellar: :any,                 sonoma:        "4297e87be8d6d5ac187f0dfce3d963c51ab77e882d743d69b72b93284ad2c33a"
    sha256 cellar: :any,                 ventura:       "4677fce731872ffe0aa7780e382fe9146a3eb83e76f7638a9515aff79944fd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249d1fc0520de693f2895dbbcce5884d63ab6eb0a5dd06d44f50c56eb32895f3"
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
