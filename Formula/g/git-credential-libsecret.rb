class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.42.0.tar.xz"
  sha256 "3278210e9fd2994b8484dd7e3ddd9ea8b940ef52170cdb606daa94d887c93b0d"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03239dd55d5a27b4ff92c0e0dd33e3cbf5cf22c479eaa2ca893fa9d201669951"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28f0cb50d9d232d8d08f163b3e9e5bb09daaf4c7c0a20d0f62f2d4746140f657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae03b9e7c2999c12ba7d94b14e475dd88043ceb151e00546e43a668bebaf1e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbdfff905373151e25d49cb34cd682fc873f0df9792b1a47c3ad393a03c737aa"
    sha256 cellar: :any,                 sonoma:         "40b65178f13df28634aca6cf83a48bc028b88718c6d3f5c854f6a84c91cd72ed"
    sha256 cellar: :any_skip_relocation, ventura:        "001a599c5e79e05253f9314c4ff95db40b5e8f4948291f89196a4c678f012bff"
    sha256 cellar: :any_skip_relocation, monterey:       "8fef0a7f29ffa32a6d8b289b67eba7316436f44a785e85e2aee45b85fcbc2133"
    sha256 cellar: :any_skip_relocation, big_sur:        "1729f8c0f40937c777b266705773e25a08cfca5449cf5175c0824991969571f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482369dbddd23ee26d8db4b11266b90c8d4f858ef523bfb1daf59843a1a4a660"
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
