class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.2.tar.xz"
  sha256 "c73d0c4fa5dcebdb2ccc293900952351cc5fb89224bb133c116305f45ae600f3"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "acb839b5afbc60a2ff80c9ef1875de1a9e2f3796024a96677111360e686e40e0"
    sha256 cellar: :any,                 arm64_big_sur:  "b884b34e6cee884df6a3f7d39fffbc63c9e3c12cd86a881116722e2eb696a2ba"
    sha256 cellar: :any,                 monterey:       "7bddf11f1e6e34af10f45751d91c5b14de29d909bf7eda85ec93d71017b73b9c"
    sha256 cellar: :any,                 big_sur:        "f6047fea127f586a364cc88a07ded89c7475551917bcb37d9f9dadbbe63def73"
    sha256 cellar: :any,                 catalina:       "3b8697883d3a76a165599b0200da6ca002b38a1ddab4d2efac1294dcc286af3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96317944d29d474ecb49efd43597cb6c3912653fc73a9b48c3590ed688e7894"
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
