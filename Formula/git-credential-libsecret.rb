class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.1.tar.xz"
  sha256 "c8162c6b8b8f1c5db706ab01b4ee29e31061182135dc27c4860224aaec1b3500"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c63b4fc572a9e13d69edbc84c91c190b9d723bad10c138b1502478305fb975d"
    sha256 cellar: :any,                 arm64_big_sur:  "538737c5fda22960d62c3f787c029617e0630b8b1c2db4c167ff86b719a68986"
    sha256 cellar: :any,                 monterey:       "f0c5cc974a40464d7e8943fd2531db4966158a563369cde71e08113463299fab"
    sha256 cellar: :any,                 big_sur:        "66a73d05cf59d20f8941b9301e87e0da0003a5d918cdf95c8740a9306f8298ec"
    sha256 cellar: :any,                 catalina:       "9ec3cdea68281e4182156254c9798dae4311a0338c05db90a5318aaf32729eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240b7f20a99d75a5237a90548959e2933e8efbfb2409541bdaab49dde8d2cb67"
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
